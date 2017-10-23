#!/bin/bash
OUTPUT="/var/www/transparency.xmpp.is/connections.txt"

{ echo "c2s:show()"; echo "s2s:show()"; sleep 1; } | telnet localhost 5582 | grep -a "Total:" > "${OUTPUT}"

sed -i 's/| OK: Total: //g' "${OUTPUT}"
sed -i 's/connections//g' "${OUTPUT}"

sed -i '/clients/i \
C2S Connections' "${OUTPUT}"

sed -i '/clients/a \
' "${OUTPUT}"

sed -i '/outgoing/i \
S2S Connections' "${OUTPUT}"
