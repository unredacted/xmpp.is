#!/bin/bash
# This script telnets into localhost port 5582 and grabs the number of C2S sessions

TMP_OUTPUT="/tmp/connection-stats.txt"
OUTPUT="/var/www/transparency.xmpp.is/connection-stats.txt"

# Sleep random amount of time between 1 - 30 seconds
sleep $[ ( $RANDOM % 30 )  + 1 ]s

# Telnet in and grep for needed line
{ echo "c2s:show()"; sleep 1; } | telnet localhost 5582 | grep -a "OK:" > "${TMP_OUTPUT}"

# Cleanup and format
sed -i 's/| OK: //g' "${TMP_OUTPUT}"
sed -i 's/c2s sessions shown/C2S connections/g' "${TMP_OUTPUT}"
sed -i '/connections/i \
Currently serving:' "${TMP_OUTPUT}"

# Change modification time
touch -m -d '1 Jan 1984 12:00' "${TMP_OUTPUT}"

# Copy temp output to actual file
mv "${TMP_OUTPUT}" "${OUTPUT}"
