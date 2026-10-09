#!/bin/bash
# This script telnets into localhost port 5582 and grabs the number of C2S sessions
#
# Uses c2s:count() rather than c2s:show(): Prosody is single-threaded, and
# c2s:show() sorts and formats a row for every session, which blocked the whole
# server for ~3 seconds on every run. c2s:count() returns the same total instantly.

TMP_OUTPUT="/tmp/connection-stats.txt"
OUTPUT="/var/www/transparency.xmpp.is/connection-stats.txt"

# Sleep random amount of time between 1 - 30 seconds
sleep $[ ( $RANDOM % 30 )  + 1 ]s

# Telnet in and grab the total ("OK: Total: N clients")
COUNT=$({ echo "c2s:count()"; sleep 1; } | telnet localhost 5582 2>/dev/null | grep -a "OK: Total:" | grep -aoE "[0-9]+" | head -n 1)

# Keep the previous stats if Prosody didn't answer
if [ -z "${COUNT}" ]; then
  exit 1
fi

# Format
printf "Currently serving:\n%s C2S connections\n" "${COUNT}" > "${TMP_OUTPUT}"

# Change modification time
touch -m -d '1 Jan 1984 12:00' "${TMP_OUTPUT}"

# Copy temp output to actual file
mv "${TMP_OUTPUT}" "${OUTPUT}"
