from hashicorp/vault:latest


RUN mkdir -p /vault/config

COPY ./config/vault.json /vault/config/vault.json