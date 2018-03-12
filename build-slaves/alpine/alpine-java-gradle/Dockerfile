FROM inetsoftware/alpine-jenkins-base
LABEL maintainer contact@inetsoftware.de

COPY install-gradle.sh /tmp
RUN bash /tmp/install-gradle.sh

RUN apk add --update --no-cache libstdc++ fontconfig msttcorefonts-installer ttf-dejavu && \
    update-ms-fonts && \
    fc-cache -f
