#!/bin/bash
# This script prevents massive bruteforce attacks against accounts
#
# Enable by writing "1" to the flag file, disable by writing "0".

PROSODY_IP="/home/user/flags/prosody-ip"
ANTI_BRUTEFORCE_FLAG="/home/user/flags/anti-bruteforce"
LOCK_FILE="/tmp/anti-bruteforce.lock"
SORTED_EXCESS_CONNECTIONS="/tmp/sorted_excess_c2s_connections.txt"
BLOCKED_PORTS="5222 5223"
MAX_UNAUTHED_PER_IP=10
BLOCK_SECONDS=299

# Check the flag to see if we should run
if grep -q "1" "${ANTI_BRUTEFORCE_FLAG}"; then
  echo "Flag is set to 1, continuing!"
else
  echo "Flag is set to 0, exiting!"
  exit
fi

# Prevent duplicate runs (the previous run sleeps for ~5 minutes while its blocks are active).
# This used to grep `ps aux` for the script name, which always matched the script itself and
# set the flag to 0 on every run, silently disabling the script.
exec 9> "${LOCK_FILE}"
if ! flock -n 9; then
  echo "The script is already running, exiting!"
  exit
fi

# Update Prosody IP
dig A prosody.xmpp.is +short > "${PROSODY_IP}"
CAT_PROSODY_IP=$(cat "${PROSODY_IP}")

# Find IP addresses with many C2S connections that haven't authenticated.
# This walks the session table directly instead of calling c2s:show(), which sorts and
# formats every session and blocked single-threaded Prosody for ~3 seconds per call.
QUERY='>(function() local c = require"prosody.core.modulemanager".get_module("*", "c2s"); if not c then return "" end; local per = {}; for _, s in pairs(c.module:shared("sessions")) do if s.type == "c2s_unauthed" and s.ip then per[s.ip] = (per[s.ip] or 0) + 1 end end; local out = {}; for ip, n in pairs(per) do if n > '"${MAX_UNAUTHED_PER_IP}"' then out[#out + 1] = ip end end; return table.concat(out, " ") end)()'
{ echo "${QUERY}"; sleep 1; } | telnet localhost 5582 2>/dev/null | grep -a "Result:" | sed 's/.*Result://' | tr ' ' '\n' \
  | grep -E "^([0-9]{1,3}\.){3}[0-9]{1,3}$" | grep -vxF "${CAT_PROSODY_IP:-0.0.0.0}" | grep -vxF "127.0.0.1" > "${SORTED_EXCESS_CONNECTIONS}"

# Remove the blocks again when we exit, even if interrupted
function remove_blocks {
  while read IP; do
    for PORT in ${BLOCKED_PORTS}; do
      /sbin/iptables -D INPUT -p tcp -s "${IP}" --dport "${PORT}" -j REJECT
    done
  done < "${SORTED_EXCESS_CONNECTIONS}"
}
trap remove_blocks EXIT

# Drop connections from sorted IP list
while read IP; do
  for PORT in ${BLOCKED_PORTS}; do
    /sbin/iptables -A INPUT -p tcp -s "${IP}" --dport "${PORT}" -j REJECT
  done
done < "${SORTED_EXCESS_CONNECTIONS}"

# Keep the blocks for a while, they are removed on exit
sleep "${BLOCK_SECONDS}"
