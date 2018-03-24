#!/bin/bash
# This script is used to find and delete offline messages larger than 1MB to prevent storage DoS

PROSODY_DATA_DIR="/var/lib/prosody"

find "${PROSODY_DATA_DIR}"/xmpp%2eis/offline -name "*.list" -size +1M -delete
find "${PROSODY_DATA_DIR}"/xmpp%2eco/offline -name "*.list" -size +1M -delete
find "${PROSODY_DATA_DIR}"/xmpp%2ecx/offline -name "*.list" -size +1M -delete
find "${PROSODY_DATA_DIR}"/xmpp%2exyz/offline -name "*.list" -size +1M -delete
find "${PROSODY_DATA_DIR}"/xmpp%2efi/offline -name "*.list" -size +1M -delete
find "${PROSODY_DATA_DIR}"/xmpp%2esi/offline -name "*.list" -size +1M -delete
find "${PROSODY_DATA_DIR}"/y2qmqomqpszzryei%2eonion/offline -name "*.list" -size +1M -delete
