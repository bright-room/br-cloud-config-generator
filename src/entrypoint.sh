#! /bin/bash

set -euo pipefail

GENERATE_BASE_DIR="/generated"
rm -fr ${GENERATE_BASE_DIR}/${SERVER_NAME}
mkdir ${GENERATE_BASE_DIR}/${SERVER_NAME}

# exec generator
bash /opt/generate_user_config.sh
if [[ ${SERVER_NAME} =~ ^.*gateway.+$ ]];then
  bash /opt/generate_network_config.sh
fi
