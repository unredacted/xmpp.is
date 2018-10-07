#!/bin/bash
# This script prevents massive bruteforce attacks against accounts

SCRIPT_NAME="anti-bruteforce.sh"
PROSODY_IP="/home/user/flags/prosody-ip"
CAT_PROSODY_IP=`cat /home/user/flags/prosody-ip`
ANTI_BRUTEFORCE_FLAG="/home/user/flags/anti-bruteforce"
SORTED_EXCESS_CONNECTIONS="/tmp/sorted_excess_c2s_connections.txt"
EXCESS_CONNECTIONS="/tmp/excess_c2s_connections.txt"

# Check the flag to see if we should run
if grep "1" "${ANTI_BRUTEFORCE_FLAG}"; then
  echo "Flag is set to 1, continuing!"
else
  echo "Flag is set to 0, exiting!"
  exit
fi

# Check if script is running when flag is set to 1
if ps aux | grep "${SCRIPT_NAME}" | grep -v grep; then
  echo "The script is already running, setting flag to 0!"
  echo "0" > "${ANTI_BRUTEFORCE_FLAG}"
  exit
else
 echo "The script is not running, continuing!"
fi

# Update Prosody IP
dig A prosody.xmpp.is +short > "${PROSODY_IP}"

# Set flag to prevent duplicate runs
echo "0" > "${ANTI_BRUTEFORCE_FLAG}"

# Find and sort IP addresses making many C2S connections without being authenticated
{ echo "c2s:show()"; sleep 1; } | telnet localhost 5582 | grep -a c2s_unauthed | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | grep -v "${CAT_PROSODY_IP}" | grep -v 127.0.0.1 | awk '{print $1}' | cut -d: -f1 | sort | uniq -c | sort -n > "${EXCESS_CONNECTIONS}"

# Sort IP addresses and output
cat "${EXCESS_CONNECTIONS}" | awk '$1 > 10  {print}' | awk '{print $2}' > "${SORTED_EXCESS_CONNECTIONS}"

# Drop connections from sorted IP list
cat "${SORTED_EXCESS_CONNECTIONS}" | awk '{gsub("IP:", "");print}' | while read IP
  do
    /sbin/iptables -A INPUT -p tcp -s $IP --dport 5222 -j REJECT
done

# Sleep for 299 seconds and remove blocks
sleep 299; cat "${SORTED_EXCESS_CONNECTIONS}" | awk '{gsub("IP:", "");print}' | while read IP
  do
    /sbin/iptables -D INPUT -p tcp -s $IP --dport 5222 -j REJECT
done

# Set flag to allow another run
echo "1" > "${ANTI_BRUTEFORCE_FLAG}"
