#!/bin/bash
This script chown's root on the git directory and files

GIT_DIR="/home/user/git"

chown -R root:root "${GIT_DIR}"/xmpp.is
