#!/bin/bash

# Script to output the fingerprints of currently installed certificates

DIR1="xmpp.is"
DIR2="xmpp.co"
DIR3="xmpp.cx"
DIR4="xmpp.xyz"
LE_DIR="/etc/letsencrypt/live"
OUTPUT_DIR="/var/www/transparency.xmpp.is"

# Remove old file
rm -f /var/www/transparency.xmpp.is/fingerprints.txt

echo Certificate fingerprints since `date` | tee -a "${OUTPUT_DIR}"/fingerprints.txt

echo | tee -a "${OUTPUT_DIR}"/fingerprints.txt

echo "XMPP.is Fingerprints" | tee -a "${OUTPUT_DIR}"/fingerprints.txt
openssl x509 -in "${LE_DIR}/${DIR1}"/cert.pem -noout -sha1 -fingerprint >> "${OUTPUT_DIR}"/fingerprints.txt
openssl x509 -in "${LE_DIR}/${DIR1}"/cert.pem -noout -sha256 -fingerprint >> "${OUTPUT_DIR}"/fingerprints.txt

echo | tee -a "${OUTPUT_DIR}"/fingerprints.txt

echo "XMPP.co Fingerprints" | tee -a "${OUTPUT_DIR}"/fingerprints.txt
openssl x509 -in "${LE_DIR}/${DIR2}"/cert.pem -noout -sha1 -fingerprint >> "${OUTPUT_DIR}"/fingerprints.txt
openssl x509 -in "${LE_DIR}/${DIR2}"/cert.pem -noout -sha256 -fingerprint >> "${OUTPUT_DIR}"/fingerprints.txt

echo | tee -a "${OUTPUT_DIR}"/fingerprints.txt

echo "XMPP.cx Fingerprints" | tee -a "${OUTPUT_DIR}"/fingerprints.txt
openssl x509 -in "${LE_DIR}/${DIR3}"/cert.pem -noout -sha1 -fingerprint >> "${OUTPUT_DIR}"/fingerprints.txt
openssl x509 -in "${LE_DIR}/${DIR3}"/cert.pem -noout -sha256 -fingerprint >> "${OUTPUT_DIR}"/fingerprints.txt

echo | tee -a "${OUTPUT_DIR}"/fingerprints.txt

echo "XMPP.xyz Fingerprints" | tee -a "${OUTPUT_DIR}"/fingerprints.txt
openssl x509 -in "${LE_DIR}/${DIR4}"/cert.pem -noout -sha1 -fingerprint >> "${OUTPUT_DIR}"/fingerprints.txt
openssl x509 -in "${LE_DIR}/${DIR4}"/cert.pem -noout -sha256 -fingerprint >> "${OUTPUT_DIR}"/fingerprints.txt
