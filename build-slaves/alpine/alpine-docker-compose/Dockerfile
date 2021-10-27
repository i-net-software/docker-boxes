FROM inetsoftware/alpine-jenkins-base
LABEL maintainer contact@inetsoftware.de

# Tools
RUN apk add --update --no-cache docker docker-compose

RUN apk add --update --no-cache nodejs npm \
    && npm install -g dockerfile-template

ADD "start.sh" "start.sh"

ENTRYPOINT [ "/bin/bash", "./start.sh" ]