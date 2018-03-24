#!/bin/bash
# Script to output the fingerprints of currently installed certificates

LE_DIR="/home/user/git/dehydrated/certs/all"
PROSODY_DIR="/etc/prosody/certs"
HS1="y2qmqomqpszzryei.onion"
TEMP_OUTPUT_FILE="/tmp/fingerprints.txt"
OUTPUT_FILE="/var/www/transparency.xmpp.is/fingerprints.txt"

# Empty old file
echo -n "" > "${TEMP_OUTPUT_FILE}"

# Update with current time
echo Certificate fingerprints since `date` | tee -a "${TEMP_OUTPUT_FILE}"

echo | tee -a "${TEMP_OUTPUT_FILE}"

echo "XMPP.* Fingerprints" | tee -a "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${LE_DIR}"/cert.pem -noout -sha1 -fingerprint >> "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${LE_DIR}"/cert.pem -noout -sha256 -fingerprint >> "${TEMP_OUTPUT_FILE}"

echo | tee -a "${TEMP_OUTPUT_FILE}"

echo "y2qmqomqpszzryei.onion Fingerprints" | tee -a "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${PROSODY_DIR}/${HS1}"/cert.pem -noout -sha1 -fingerprint >> "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${PROSODY_DIR}/${HS1}"/cert.pem -noout -sha256 -fingerprint >> "${TEMP_OUTPUT_FILE}"

cp "${TEMP_OUTPUT_FILE}" "${OUTPUT_FILE}"
