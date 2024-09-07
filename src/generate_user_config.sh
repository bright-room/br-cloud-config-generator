#! /bin/bash

set -euo pipefail

CREDENTIAL_FILE="/credentials/${SERVER_NAME}.yaml"
TEMPLATE_FILE="/templates/user-data.j2"
GENERATED_FILE="/generated/${SERVER_NAME}/user-data"

# user data define
root_password=$(openssl passwd -6 -salt=salt $(yq ".users.root.password" "${CREDENTIAL_FILE}"))
operation_user_name=$(yq ".users.operation_user.user_name" "${CREDENTIAL_FILE}")
operation_user_password=$(openssl passwd -6 -salt=salt $(yq ".users.operation_user.password" "${CREDENTIAL_FILE}"))
operation_user_public_key=$(yq ".users.operation_user.public_key" "${CREDENTIAL_FILE}")

generate_target="gateway"
if [[ ${SERVER_NAME} =~ ^br-node.+$ ]];then
  generate_target="node"
fi

echo "${generate_target}"

jinja2 ${TEMPLATE_FILE} \
      -D "hostname=${SERVER_NAME}" \
      -D "root_password=${root_password}" \
      -D "operation_user_name=${operation_user_name}" \
      -D "operation_user_password=${operation_user_password}" \
      -D "operation_user_public_key=${operation_user_public_key}" \
      -D "generate_target=${generate_target}" \
      > ${GENERATED_FILE}
