#!/bin/bash

# Add jenkins user to docker.sock group
# This container is practically only for this use case
DOCKER_SOCK="/var/run/docker.sock"
if [ -e "${DOCKER_SOCK}" ]; then
    GID=$(stat  -c %g "${DOCKER_SOCK}")
    sudo addgroup -g ${GID} -S docker_
    sudo addgroup jenkins docker_
fi

exec "$@"
