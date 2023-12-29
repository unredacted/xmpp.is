#!/bin/bash
# Script to output the fingerprints of currently installed certificates

LE_DIR="/etc/letsencrypt/live/xmpp.is"
PROSODY_DIR="/etc/prosody/certs"
HS1="y2qmqomqpszzryei.onion"
HS2="6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion"
TEMP_OUTPUT_FILE="/tmp/fingerprints.txt"
OUTPUT_FILE="/var/www/transparency.xmpp.is/fingerprints.txt"

# Empty old file
echo -n "" > "${TEMP_OUTPUT_FILE}"

# Update with current time
echo Certificate fingerprints since `date` | tee -a "${TEMP_OUTPUT_FILE}"

echo | tee -a "${TEMP_OUTPUT_FILE}"

# Output SHA1 & SHA256 hashes for *.xmpp.* wildcard
echo "XMPP.* Fingerprints" | tee -a "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${PROSODY_DIR}"/xmpp.is.crt -noout -sha1 -fingerprint >> "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${PROSODY_DIR}"/xmpp.is.crt -noout -sha256 -fingerprint >> "${TEMP_OUTPUT_FILE}"

echo | tee -a "${TEMP_OUTPUT_FILE}"

# Output SHA1 & SHA256 hashes for hidden service certificate
echo "y2qmqomqpszzryei.onion Fingerprints" | tee -a "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${PROSODY_DIR}/${HS1}"/cert.pem -noout -sha1 -fingerprint >> "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${PROSODY_DIR}/${HS1}"/cert.pem -noout -sha256 -fingerprint >> "${TEMP_OUTPUT_FILE}"

echo | tee -a "${TEMP_OUTPUT_FILE}"

echo "6voaf7iamjpufgwoulypzwwecsm2nu7j5jpgadav2rfqixmpl4d65kid.onion Fingerprints" | tee -a "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${PROSODY_DIR}/${HS2}"/cert.pem -noout -sha1 -fingerprint >> "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${PROSODY_DIR}/${HS2}"/cert.pem -noout -sha256 -fingerprint >> "${TEMP_OUTPUT_FILE}"

# Copy temp file to actual file
cp "${TEMP_OUTPUT_FILE}" "${OUTPUT_FILE}"
