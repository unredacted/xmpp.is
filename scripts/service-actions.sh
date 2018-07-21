#!/bin/bash
# Script that checks flags for service actions

TOR_RESTART_FLAG="/home/user/flags/tor-restart"

# Tor service actions
if grep "1" "${TOR_RESTART_FLAG}"; then
  service tor stop
  sleep 10
  service tor start
  echo "Tor has been restarted, setting flag back to 0!"
  echo "0" > "${TOR_RESTART_FLAG}"
else
  echo "The flag is set to 0, exiting now!"
  exit
fi
