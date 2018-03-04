#!/bin/bash
# This script prevents massive bruteforce attacks against accounts

# Find and sort IP addresses making many C2S connections without being authenticated
{ echo "c2s:show()"; sleep 1; } | telnet localhost 5582 | grep -a c2s_unauthed | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | grep -v '144.76.47.248' | grep -v 127.0.0.1 | awk '{print $1}' | cut -d: -f1 | sort | uniq -c | sort -n > /tmp/excess_c2s_connections.txt

# Sort IP addresses and output
cat /tmp/excess_c2s_connections.txt | awk '$1 > 20  {print}' | awk '{print $2}' > /tmp/sorted_excess_c2s_connections.txt

# Drop connections from sorted IP list
cat /tmp/sorted_excess_c2s_connections.txt | awk '{gsub("IP:", "");print}' | while read IP
do
  /sbin/iptables -A INPUT -s $IP --dport 5222 -j REJECT
done

# Sleep for 295 seconds and remove blocks
sleep 295; cat /tmp/sorted_excess_c2s_connections.txt | awk '{gsub("IP:", "");print}' | while read IP
do
  /sbin/iptables -D INPUT -s $IP --dport 5222 -j REJECT
done
