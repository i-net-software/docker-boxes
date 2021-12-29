FROM inetsoftware/alpine-jenkins-base
LABEL maintainer contact@inetsoftware.de

# Tools
RUN apk add --update --no-cache docker

RUN TARGET_ARCH=x86_64 ; \
    DOCKER_CLI_DIR=/usr/lib/docker/cli-plugins ; \
    mkdir -p "${DOCKER_CLI_DIR}" && \
    DOCKER_COMPOSE_URL="https://github.com/docker/compose/releases/download/${DOCKER_COMPOSEV2_VERSION-v2.2.2}/docker-compose-linux-${TARGET_ARCH}" && \
    echo "Docker Compose URL: '${DOCKER_COMPOSE_URL}'" && \
    curl -fsSL "${DOCKER_COMPOSE_URL}" -o "${DOCKER_CLI_DIR}/docker-compose" && \
    chmod +x "${DOCKER_CLI_DIR}/docker-compose" && \
    docker --version && docker compose version

# Provide switching script for earlier scripts
RUN curl -fL https://raw.githubusercontent.com/docker/compose-switch/master/install_on_linux.sh | sh || true ; \
    # the install script is not really intended for this environment
    ln -s /usr/local/bin/compose-switch /usr/local/bin/docker-compose && \
    docker --version && docker compose version && docker-compose version

RUN apk add --update --no-cache nodejs npm \
    && npm install -g dockerfile-template

ADD "start.sh" "start.sh"

ENTRYPOINT [ "/bin/bash", "./start.sh" ]