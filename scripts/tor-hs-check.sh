#!/bin/bash
# Script to check in the Tor Hidden Services are reachable

TOR_RESTART_FLAG="/home/user/flags/tor-restart"
HSV3="6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion"
HSV2="y2qmqomqpszzryei.onion"

# Checks Tor log for common errors, and sets flag if needed
function check_logs {
echo "Parsing logs now!"
if sed -n "/^$(date --date='5 minutes ago' '+%b %_d %H')/,\$p" /var/log/tor/notice.log | grep "No more HSDir available to query"; then
  echo "1" > "${TOR_RESTART_FLAG}"
fi
echo "Done parsing logs!"
}

# Performs a curl test on the hidden service
function curl_test {
echo "Checking HSv2"
if torsocks curl --max-time 30 "${HSV2}":5222/ | grep "xml" | grep "stream" > /dev/null 2>&1
  then
    echo "The Tor HSv2 "${HSV2}":5222 was reachable!" > /dev/null 2>&1
  else
    echo "The Tor HSv2 "${HSV2}":5222 is unreachable!" | mail -s "Tor HSv2 Down" cron@lunar.systems
fi

echo "Checking HSv3"
if torsocks curl --max-time 30 "${HSV3}":5222/ | grep "xml" | grep "stream" > /dev/null 2>&1
  then
    echo "The Tor HSv3 "${HSV3}":5222 is reachable!" > /dev/null 2>&1
  else
    echo "The Tor HSv3 "${HSV3}":5222 is unreachable!" | mail -s "Tor HSv3 Down" cron@lunar.systems
fi
}

# Magic code for flags
while [ ! $# -eq 0 ]
do
case "$1" in

  --curl | -c)
  curl_test
  ;;

  --check-logs | -l)
  check_logs
  ;;

  *)
  echo "Unknown parameter detected: ${1}" >&2
  exit 1
  ;;

esac
shift
done
