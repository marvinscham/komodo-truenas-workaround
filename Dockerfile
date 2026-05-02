FROM ghcr.io/moghtech/komodo-periphery:2

RUN set -e; \
  apt-get update; \
  apt-get install -y --allow-downgrades \
    docker-ce-cli=5:28.* \
    docker-compose-plugin=5.0.* \
    ; \
  rm -rf /var/lib/apt/lists/*;
