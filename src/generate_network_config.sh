#! /bin/bash

set -euo pipefail

CREDENTIAL_FILE="/credentials/${SERVER_NAME}.yaml"
TEMPLATE_FILE="/templates/network-config.j2"
GENERATED_FILE="/generated/${SERVER_NAME}/network-config"

# network define
internal_ip_address=$(yq ".networks.internal.ip_address" "${CREDENTIAL_FILE}")
external_ip_address=$(yq ".networks.external.ip_address" "${CREDENTIAL_FILE}")
external_gateway_ip_address=$(yq ".networks.external.gateway_ip" "${CREDENTIAL_FILE}")
ssid=$(yq ".networks.external.wifi.ssid" "${CREDENTIAL_FILE}")
passphrase=$(yq ".networks.external.wifi.passphrase" "${CREDENTIAL_FILE}")

# generate wifi hashed passphrase
wpa_passphrase "${ssid}" "${passphrase}" > /tmp/wpa_config.txt
hashed_passphrase=$(cat /tmp/wpa_config.txt | sed -E 's/^[ \t]+//' | grep -E '^psk=' | cut -d'=' -f 2)

# generate config file
jinja2 ${TEMPLATE_FILE} \
      -D "internal_ip_address=${internal_ip_address}" \
      -D "external_ip_address=${external_ip_address}" \
      -D "external_gateway_ip=${external_gateway_ip_address}" \
      -D "ssid=${ssid}" \
      -D "hashed_password=${hashed_passphrase}" \
      > ${GENERATED_FILE}
