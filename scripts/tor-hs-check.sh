#!/bin/bash
# Script to check in the Tor Hidden Services are reachable

TOR_RESTART_FLAG="/tmp/flags/tor-restart"

if torsocks curl --max-time 30 y2qmqomqpszzryei.onion:5222/ | grep "xml" | grep "stream" > /dev/null
  then
    echo "The Tor HSv2 y2qmqomqpszzryei.onion:5222 was reachable!" > /dev/null
  else
    echo "The Tor HSv2 y2qmqomqpszzryei.onion:5222 is unreachable!" | mail -s "Tor HSv2 Down" cron@lunar.systems
fi

if torsocks curl --max-time 30 6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion:5222/ | grep "xml" | grep "stream" > /dev/null
  then
    echo "The Tor HSv3 6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion:5222 is reachable!" > /dev/null
  else
    echo "The Tor HSv3 6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion:5222 is unreachable!" | mail -s "Tor HSv3 Down" cron@lunar.systems
fi

if sed -n "/^$(date --date='5 minutes ago' '+%b %_d %H')/,\$p" /var/log/tor/notice.log | grep "No more HSDir available to query"; then
  echo "1" > "${TOR_RESTART_FLAG}"
fi
