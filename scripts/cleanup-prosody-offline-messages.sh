#!/bin/sh
# This script is used to find and delete offline messages larger than 1MB to prevent storage DoS

find /var/lib/prosody/xmpp%2eis/offline -name "*.list" -size +1M -delete
find /var/lib/prosody/xmpp%2eco/offline -name "*.list" -size +1M -delete
find /var/lib/prosody/xmpp%2ecx/offline -name "*.list" -size +1M -delete
find /var/lib/prosody/xmpp%2exyz/offline -name "*.list" -size +1M -delete
find /var/lib/prosody/xmpp%2efi/offline -name "*.list" -size +1M -delete
find /var/lib/prosody/y2qmqomqpszzryei%2eonion/offline -name "*.list" -size +1M -delete
