FROM python:3.12.6-slim-bullseye

RUN apt-get update \
    && apt-get install -y --no-install-recommends jq wget wpasupplicant \
    && wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq \
    && chmod +x /usr/bin/yq \
    && pip install jinja2-cli jinja2-cli[yaml]

COPY --chmod=755 ./src/entrypoint.sh /opt/entrypoint.sh
COPY --chmod=755 ./src/generate_user_config.sh /opt/generate_user_config.sh
COPY --chmod=755 ./src/generate_network_config.sh /opt/generate_network_config.sh

COPY ./template /templates/

ENTRYPOINT [ "/opt/entrypoint.sh" ]
