FROM inetsoftware/alpine-jenkins-base
LABEL maintainer contact@inetsoftware.de

# Docker and Compose scripts. This requires a newer version of alpine
# But we can not give that by default due to problems with IPv6 resolution
RUN sed -i -e 's/v3\.1\d/v3.15/g' /etc/apk/repositories ;\
    apk add --update --no-cache docker docker-cli-compose && \
    # Provide switching script for earlier scripts
    curl -fL https://raw.githubusercontent.com/docker/compose-switch/master/install_on_linux.sh | sh || true ; \
    # the install script is not really intended for this environment
    ln -s /usr/local/bin/compose-switch /usr/local/bin/docker-compose && \
    docker --version && docker compose version && docker-compose version

RUN apk add --update --no-cache nodejs npm \
    && npm install -g dockerfile-template

ADD "start.sh" "start.sh"

ENTRYPOINT [ "/bin/bash", "./start.sh" ]