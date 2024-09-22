#! /bin/bash

set -euo pipefail

CREDENTIAL_FILE="/credentials/${SERVER_NAME}.yaml"
TEMPLATE_FILE="/templates/user-data.j2"
GENERATED_FILE="/generated/${SERVER_NAME}/user-data"

if [[ ${SERVER_NAME} =~ ^.*node.+$ ]]; then
  export GENERATE_TARGET="node"
else
  export GENERATE_TARGET="gateway"
fi

jinja2 --format=yaml ${TEMPLATE_FILE} ${CREDENTIAL_FILE} > ${GENERATED_FILE}
