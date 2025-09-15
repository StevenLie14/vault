FROM hashicorp/vault:latest


RUN mkdir -p /vault/config

COPY ./config/vault-config.json /vault/config/vault-config.json