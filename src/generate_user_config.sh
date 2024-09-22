#! /bin/bash

set -euo pipefail

CREDENTIAL_FILE="/credentials/${SERVER_NAME}.yaml"
TEMPLATE_FILE="/templates/user-data.j2"
GENERATED_FILE="/generated/${SERVER_NAME}/user-data"

root_password=$(openssl passwd -6 -salt=salt $(yq ".users.root.password" "${CREDENTIAL_FILE}"))
operation_user_password=$(openssl passwd -6 -salt=salt $(yq ".users.operation_user.password" "${CREDENTIAL_FILE}"))

if [[ ${SERVER_NAME} =~ ^.*node.+$ ]]; then
  export GENERATE_TARGET="node"
else
  export GENERATE_TARGET="gateway"
fi

jinja2 --format=yaml ${TEMPLATE_FILE} ${CREDENTIAL_FILE} \
      -D "root_password=${root_password}" \
      -D "operation_user_password=${operation_user_password}" \
      > ${GENERATED_FILE}
