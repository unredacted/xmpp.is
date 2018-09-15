#!/bin/bash
# Script to check in the Tor Hidden Services are reachable
EMAIL="cron@lunar.systems"

# NFS variables
NFS_MOUNT="/nfs"

# Tor variables
TOR_RESTART_FLAG="/home/user/flags/tor-restart"
TOR_NOTICE_LOG="/var/log/tor/notice.log"
HSV3="6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion"
HSV2="y2qmqomqpszzryei.onion"

# Check NFS mount
function nfs_check_mount {
if mount | grep "${NFS_MOUNT}" > /dev/null; then
  echo "The mount point shows up!" > /dev/null
else
  echo "The mount point does not show up on "${HOSTNAME}"" | mail -s "NFS Mount Issue" "${EMAIL}"
fi
}

# Checks Tor log for common errors, and sets flag if needed
function tor_check_logs {
echo "Parsing logs now!"
if sed -n "/^$(date --date='5 minutes ago' '+%b %_d %H')/,\$p" "${TOR_NOTICE_LOG}" | grep "No more HSDir available to query"; then
  echo "1" > "${TOR_RESTART_FLAG}"
fi
echo "Done parsing logs!"
}

# Performs a curl test on the hidden service
function tor_curl_test {
echo "Checking HSv2"
if torsocks curl --max-time 30 "${HSV2}":5222/ | grep "xml" | grep "stream" > /dev/null 2>&1
  then
    echo "The Tor HSv2 "${HSV2}":5222 was reachable!" > /dev/null 2>&1
  else
    echo "The Tor HSv2 "${HSV2}":5222 is unreachable!" | mail -s "Tor HSv2 Down" "${EMAIL}"
fi

echo "Checking HSv3"
if torsocks curl --max-time 30 "${HSV3}":5222/ | grep "xml" | grep "stream" > /dev/null 2>&1
  then
    echo "The Tor HSv3 "${HSV3}":5222 is reachable!" > /dev/null 2>&1
  else
    echo "The Tor HSv3 "${HSV3}":5222 is unreachable!" | mail -s "Tor HSv3 Down" "${EMAIL}"
fi
}

# Magic code for flags
while [ ! $# -eq 0 ]
do
case "$1" in

  --nfs-check-mount)
  nfs_check_mount
  ;;

  --tor-curl-test)
  tor_curl_test
  ;;

  --tor-check-logs)
  tor_check_logs
  ;;

  *)
  echo "Unknown parameter detected: ${1}" >&2
  exit 1
  ;;

esac
shift
done
