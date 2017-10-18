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
OUTPUT_DIR="/var/www/transparency.xmpp.is"

# Empty old file
echo -n "" > /var/www/transparency.xmpp.is/fingerprints.txt

# Update with current time
echo Certificate fingerprints since `date` | tee -a "${OUTPUT_DIR}"/fingerprints.txt

echo | tee -a "${OUTPUT_DIR}"/fingerprints.txt

echo "XMPP.is Fingerprints" | tee -a "${OUTPUT_DIR}"/fingerprints.txt
openssl x509 -in "${LE_DIR}/${S1}"/cert.pem -noout -sha1 -fingerprint >> "${OUTPUT_DIR}"/fingerprints.txt
openssl x509 -in "${LE_DIR}/${S1}"/cert.pem -noout -sha256 -fingerprint >> "${OUTPUT_DIR}"/fingerprints.txt

echo | tee -a "${OUTPUT_DIR}"/fingerprints.txt

echo "XMPP.co Fingerprints" | tee -a "${OUTPUT_DIR}"/fingerprints.txt
openssl x509 -in "${LE_DIR}/${S2}"/cert.pem -noout -sha1 -fingerprint >> "${OUTPUT_DIR}"/fingerprints.txt
openssl x509 -in "${LE_DIR}/${S2}"/cert.pem -noout -sha256 -fingerprint >> "${OUTPUT_DIR}"/fingerprints.txt

echo | tee -a "${OUTPUT_DIR}"/fingerprints.txt

echo "XMPP.cx Fingerprints" | tee -a "${OUTPUT_DIR}"/fingerprints.txt
openssl x509 -in "${LE_DIR}/${S3}"/cert.pem -noout -sha1 -fingerprint >> "${OUTPUT_DIR}"/fingerprints.txt
openssl x509 -in "${LE_DIR}/${S3}"/cert.pem -noout -sha256 -fingerprint >> "${OUTPUT_DIR}"/fingerprints.txt

echo | tee -a "${OUTPUT_DIR}"/fingerprints.txt

echo "XMPP.xyz Fingerprints" | tee -a "${OUTPUT_DIR}"/fingerprints.txt
openssl x509 -in "${LE_DIR}/${S4}"/cert.pem -noout -sha1 -fingerprint >> "${OUTPUT_DIR}"/fingerprints.txt
openssl x509 -in "${LE_DIR}/${S4}"/cert.pem -noout -sha256 -fingerprint >> "${OUTPUT_DIR}"/fingerprints.txt

echo | tee -a "${OUTPUT_DIR}"/fingerprints.txt

echo "XMPP.fi Fingerprints" | tee -a "${OUTPUT_DIR}"/fingerprints.txt
openssl x509 -in "${LE_DIR}/${S5}"/cert.pem -noout -sha1 -fingerprint >> "${OUTPUT_DIR}"/fingerprints.txt
openssl x509 -in "${LE_DIR}/${S5}"/cert.pem -noout -sha256 -fingerprint >> "${OUTPUT_DIR}"/fingerprints.txt

echo | tee -a "${OUTPUT_DIR}"/fingerprints.txt

echo "y2qmqomqpszzryei.onion Fingerprints" | tee -a "${OUTPUT_DIR}"/fingerprints.txt
openssl x509 -in "${PROSODY_DIR}/${HS1}"/cert.pem -noout -sha1 -fingerprint >> "${OUTPUT_DIR}"/fingerprints.txt
openssl x509 -in "${PROSODY_DIR}/${HS1}"/cert.pem -noout -sha256 -fingerprint >> "${OUTPUT_DIR}"/fingerprints.txt
