#!/bin/bash
# Script to output the fingerprints of currently installed certificates

S1="xmpp.is"
S2="xmpp.co"
S3="xmpp.cx"
S4="xmpp.xyz"
S5="xmpp.fi"
HS1="y2qmqomqpszzryei.onion"
LE_DIR="/etc/letsencrypt/live"
PROSODY_DIR="/etc/prosody/certs"
TEMP_OUTPUT_FILE="/tmp/fingerprints.txt"
OUTPUT_FILE="/var/www/transparency.xmpp.is/fingerprints.txt"

# Empty old file
echo -n "" > "${TEMP_OUTPUT_FILE}"

# Update with current time
echo Certificate fingerprints since `date` | tee -a "${TEMP_OUTPUT_FILE}"

echo | tee -a "${TEMP_OUTPUT_FILE}"

echo "XMPP.is Fingerprints" | tee -a "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${LE_DIR}/${S1}"/cert.pem -noout -sha1 -fingerprint >> "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${LE_DIR}/${S1}"/cert.pem -noout -sha256 -fingerprint >> "${TEMP_OUTPUT_FILE}"

echo | tee -a "${TEMP_OUTPUT_FILE}"

echo "XMPP.co Fingerprints" | tee -a "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${LE_DIR}/${S2}"/cert.pem -noout -sha1 -fingerprint >> "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${LE_DIR}/${S2}"/cert.pem -noout -sha256 -fingerprint >> "${TEMP_OUTPUT_FILE}"

echo | tee -a "${TEMP_OUTPUT_FILE}"

echo "XMPP.cx Fingerprints" | tee -a "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${LE_DIR}/${S3}"/cert.pem -noout -sha1 -fingerprint >> "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${LE_DIR}/${S3}"/cert.pem -noout -sha256 -fingerprint >> "${TEMP_OUTPUT_FILE}"

echo | tee -a "${TEMP_OUTPUT_FILE}"

echo "XMPP.xyz Fingerprints" | tee -a "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${LE_DIR}/${S4}"/cert.pem -noout -sha1 -fingerprint >> "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${LE_DIR}/${S4}"/cert.pem -noout -sha256 -fingerprint >> "${TEMP_OUTPUT_FILE}"

echo | tee -a "${TEMP_OUTPUT_FILE}"

echo "XMPP.fi Fingerprints" | tee -a "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${LE_DIR}/${S5}"/cert.pem -noout -sha1 -fingerprint >> "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${LE_DIR}/${S5}"/cert.pem -noout -sha256 -fingerprint >> "${TEMP_OUTPUT_FILE}"

echo | tee -a "${TEMP_OUTPUT_FILE}"

echo "y2qmqomqpszzryei.onion Fingerprints" | tee -a "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${PROSODY_DIR}/${HS1}"/cert.pem -noout -sha1 -fingerprint >> "${TEMP_OUTPUT_FILE}"
openssl x509 -in "${PROSODY_DIR}/${HS1}"/cert.pem -noout -sha256 -fingerprint >> "${TEMP_OUTPUT_FILE}"

mv "${TEMP_OUTPUT_FILE}" "${OUTPUT_FILE}"
