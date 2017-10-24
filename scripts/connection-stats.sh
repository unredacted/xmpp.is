#!/bin/bash
OUTPUT="/var/www/transparency.xmpp.is/connection-stats.txt"

{ echo "c2s:show()"; sleep 1; } | telnet localhost 5582 | grep -a "Total:" > "${OUTPUT}"

sed -i 's/| OK: Total: //g' "${OUTPUT}"
sed -i 's/clients//g' "${OUTPUT}"

sed -i '/clients/i \
Current Client Connections:' "${OUTPUT}"
