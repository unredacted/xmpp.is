#!/bin/bash
# Script downloads latest Prosody modules

cd /usr/lib/prosody/downloaded-modules && hg pull && hg update
