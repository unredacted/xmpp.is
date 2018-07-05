#!/bin/bash
# This script prevents massive bruteforce attacks against accounts

ANTI_BRUTEFORCE_FLAG="/tmp/flags/anti-bruteforce"

# Check the flag to see if we should run
if grep "1" "${ANTI_BRUTEFORCE_FLAG}"; then
  echo "Flag is set to 1, running!"
else
  echo "Flag is set to something other than 1, exiting!"
  exit
fi

# Set flag to prevent duplicate runs
echo "0" > "${ANTI_BRUTEFORCE_FLAG}"

# Find and sort IP addresses making many C2S connections without being authenticated
{ echo "c2s:show()"; sleep 1; } | telnet localhost 5582 | grep -a c2s_unauthed | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | grep -v '144.76.47.248' | grep -v 127.0.0.1 | awk '{print $1}' | cut -d: -f1 | sort | uniq -c | sort -n > /tmp/excess_c2s_connections.txt

# Sort IP addresses and output
cat /tmp/excess_c2s_connections.txt | awk '$1 > 10  {print}' | awk '{print $2}' > /tmp/sorted_excess_c2s_connections.txt

# Drop connections from sorted IP list
cat /tmp/sorted_excess_c2s_connections.txt | awk '{gsub("IP:", "");print}' | while read IP
  do
    /sbin/iptables -A INPUT -p tcp -s $IP --dport 5222 -j REJECT
done

# Sleep for 295 seconds and remove blocks
sleep 295; cat /tmp/sorted_excess_c2s_connections.txt | awk '{gsub("IP:", "");print}' | while read IP
  do
    /sbin/iptables -D INPUT -p tcp -s $IP --dport 5222 -j REJECT
done

# Set flag to allow another run
echo "1" > "${ANTI_BRUTEFORCE_FLAG}"
