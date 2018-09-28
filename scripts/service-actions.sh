#!/bin/bash
# Script that checks flags for service actions

TOR_RESTART_FLAG="/home/user/flags/tor-restart"
TOR_CONFIG_PATH="/etc/tor/torrc"

# Tor restart action
function tor_restart {
if grep "1" "${TOR_RESTART_FLAG}"; then
  service tor stop
else
  echo "The flag is set to 0, exiting now!"
  exit
fi

sleep 10

if ps aux | grep -v grep | grep "${TOR_CONFIG_PATH}"; then
  echo "Tor is still running, no need to start it!"
  exit
else
  service tor start
  echo "Tor has been restarted, setting flag back to 0!"
  echo "0" > "${TOR_RESTART_FLAG}"
fi
}

# Magic code for flags
while [ ! $# -eq 0 ]
do
case "$1" in

  --tor-restart)
  tor_restart
  ;;

  *)
  echo "Unknown parameter detected: ${1}" >&2
  exit 1
  ;;

esac
shift
done
