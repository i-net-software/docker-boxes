FROM inetsoftware/alpine-jenkins-base
LABEL maintainer contact@inetsoftware.de

RUN apk add --update --no-cache libstdc++

COPY install-gradle.sh /tmp
RUN bash /tmp/install-gradle.sh
