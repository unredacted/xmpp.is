#!/bin/bash
# Script to check in the Tor Hidden Services are reachable

if torsocks curl y2qmqomqpszzryei.onion:5222/ | grep "xml" | grep "stream" > /dev/null
  then
    echo "The Tor HSv2 y2qmqomqpszzryei.onion:5222 was reachable!" > /dev/null
  else
    echo "The Tor HSv2 y2qmqomqpszzryei.onion:5222 is unreachable!" | mail -s "Tor HSv2 Down" admin@lunar.systems
fi

if torsocks curl 6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion:5222/ | grep "xml" | grep "stream" > /dev/null
  then
    echo "The Tor HSv3 6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion:5222 is reachable!" > /dev/null
  else
    echo "The Tor HSv3 6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion:5222 is unreachable!" | mail -s "Tor HSv3 Down" admin@lunar.systems
fi
