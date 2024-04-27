#!/bin/bash

# Path to the renewed certificate
CERT_FILE="/etc/prosody/certs/xmpp.is.crt"

# Extract the certificate hash
CERT_HASH=$(openssl x509 -in "$CERT_FILE" -noout -pubkey | openssl pkey -pubin -outform DER | openssl dgst -sha256 | awk '{print $2}')

# Cloudflare API token from the configuration file
CF_API_TOKEN=$(awk -F " *= *" '/dns_cloudflare_api_token/ {print $2}' /root/.secrets/certbot/cloudflare.ini)

# Cloudflare Zone ID
CF_ZONE_ID="b41331eb15ef71702fee8e7c795950b1"

# Domain name
DOMAIN="xmpp.is"

# Record names
RECORD_NAMES=("_5222._tcp.prosody" "_5223._tcp.prosody" "_5269._tcp.prosody")

# TLSA record type
TLSA_RECORD_TYPE="TLSA"

# TLSA record fields
USAGE="3"
SELECTOR="1"
MATCHING_TYPE="1"

# TTL (in seconds)
TTL=60

# Update TLSA records using the Cloudflare API
for RECORD_NAME in "${RECORD_NAMES[@]}"; do
    FULL_RECORD_NAME="$RECORD_NAME.$DOMAIN"

    # Check if the TLSA record exists
    RECORD_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records?type=$TLSA_RECORD_TYPE&name=$FULL_RECORD_NAME" \
                     -H "Authorization: Bearer $CF_API_TOKEN" \
                     -H "Content-Type: application/json" | jq -r '.result[0].id')

    if [ -z "$RECORD_ID" ]; then
        # TLSA record doesn't exist, create it
        curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records" \
             -H "Authorization: Bearer $CF_API_TOKEN" \
             -H "Content-Type: application/json" \
             --data "{\"type\":\"$TLSA_RECORD_TYPE\",\"name\":\"$FULL_RECORD_NAME\",\"ttl\":$TTL,\"data\":{\"usage\":\"$USAGE\",\"selector\":\"$SELECTOR\",\"matching_type\":\"$MATCHING_TYPE\",\"certificate\":\"$CERT_HASH\"}}"
    else
        # TLSA record exists, update it
        curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records/$RECORD_ID" \
             -H "Authorization: Bearer $CF_API_TOKEN" \
             -H "Content-Type: application/json" \
             --data "{\"type\":\"$TLSA_RECORD_TYPE\",\"name\":\"$FULL_RECORD_NAME\",\"ttl\":$TTL,\"data\":{\"usage\":\"$USAGE\",\"selector\":\"$SELECTOR\",\"matching_type\":\"$MATCHING_TYPE\",\"certificate\":\"$CERT_HASH\"}}"
    fi
done