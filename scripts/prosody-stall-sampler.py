#!/usr/bin/env python3
# Measures how often Prosody's single event loop is blocked, without touching Prosody.
#
# Samples the main thread's current syscall from /proc every 50ms. Whenever the thread is
# not waiting in epoll for 0.5s or more, it is stalled: no connection is being served.
# Prints each stall (with how much of it was CPU vs waiting on e.g. PostgreSQL) and a
# per-minute summary. Read-only; needs root to read /proc/<pid>/syscall.
#
# Usage: sudo python3 prosody-stall-sampler.py [seconds] [pid]

import datetime
import os
import sys
import time

DURATION = float(sys.argv[1]) if len(sys.argv) > 1 else 300
PID = int(sys.argv[2]) if len(sys.argv) > 2 else int(open("/var/run/prosody/prosody.pid").read().strip())
INTERVAL = 0.05
MIN_STALL = 0.5
IDLE_SYSCALLS = {232, 281, 441}  # epoll_wait, epoll_pwait, epoll_pwait2 (x86_64)
WAIT_SYSCALLS = {7: "poll", 271: "ppoll", 0: "read", 45: "recvfrom", 47: "recvmsg"}
TICKS = os.sysconf("SC_CLK_TCK")
TASK = f"/proc/{PID}/task/{PID}"


def sample():
    syscall = open(f"{TASK}/syscall").read().split()
    stat = open(f"{TASK}/stat").read().rsplit(")", 1)[1].split()
    cpu_ticks = int(stat[11]) + int(stat[12])  # utime + stime
    if syscall[0] == "running":
        return "cpu", cpu_ticks
    number = int(syscall[0])
    if number in IDLE_SYSCALLS:
        return "idle", cpu_ticks
    return WAIT_SYSCALLS.get(number, f"syscall {number}"), cpu_ticks


def clock(t):
    return datetime.datetime.fromtimestamp(t).strftime("%H:%M:%S.%f")[:-3]


start = time.time()
stall = None
minutes = {}
total_stalled = 0.0
print(f"Sampling Prosody (pid {PID}) for {DURATION:.0f}s")
while time.time() - start < DURATION:
    now = time.time()
    try:
        state, cpu_ticks = sample()
    except (FileNotFoundError, ProcessLookupError):
        print("Prosody exited")
        break
    minute = minutes.setdefault(datetime.datetime.fromtimestamp(now).strftime("%H:%M"), [0, 0.0])
    if state == "idle":
        if stall:
            duration = now - stall["start"]
            if duration >= MIN_STALL:
                cpu = (cpu_ticks - stall["cpu"]) / TICKS
                states = ", ".join(f"{k} {v}" for k, v in sorted(stall["states"].items(), key=lambda kv: -kv[1]))
                print(f"stall at {clock(stall['start'])}: {duration:5.2f}s blocked, {cpu:5.2f}s CPU  [samples: {states}]")
                minute[0] += 1
                minute[1] += duration
                total_stalled += duration
            stall = None
    else:
        if not stall:
            stall = {"start": now, "cpu": cpu_ticks, "states": {}}
        stall["states"][state] = stall["states"].get(state, 0) + 1
    time.sleep(max(0, INTERVAL - (time.time() - now)))

elapsed = time.time() - start
print("\nPer minute:")
for name, (count, seconds) in sorted(minutes.items()):
    print(f"  {name}  {count:3d} stalls  {seconds:5.1f}s blocked")
print(f"\nBlocked for {total_stalled:.1f}s of {elapsed:.0f}s ({100 * total_stalled / elapsed:.0f}%) in stalls of {MIN_STALL}s or more")
