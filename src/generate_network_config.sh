#! /bin/bash

set -euo pipefail

CREDENTIAL_FILE="/credentials/${SERVER_NAME}.yaml"
TEMPLATE_FILE="/templates/network-config.j2"
GENERATED_FILE="/generated/${SERVER_NAME}/network-config"

ssid=$(yq ".networks.external.wifi.ssid" "${CREDENTIAL_FILE}")
passphrase=$(yq ".networks.external.wifi.passphrase" "${CREDENTIAL_FILE}")
wpa_passphrase "${ssid}" "${passphrase}" > /tmp/wpa_config.txt
hashed_passphrase=$(cat /tmp/wpa_config.txt | sed -E 's/^[ \t]+//' | grep -E '^psk=' | cut -d'=' -f 2)

jinja2 --format=yaml ${TEMPLATE_FILE} ${CREDENTIAL_FILE} > ${GENERATED_FILE}
jinja2 --format=yaml  ${TEMPLATE_FILE} ${CREDENTIAL_FILE} \
      -D "hashed_password=${hashed_passphrase}" \
      > ${GENERATED_FILE}
