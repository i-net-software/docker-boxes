FROM inetsoftware/fedora-jenkins-base
LABEL maintainer contact@inetsoftware.de

ENV TERM linux
RUN dnf updateinfo && dnf install -y java-11-openjdk-devel wget which

COPY install-gradle.sh /tmp
RUN bash /tmp/install-gradle.sh && rm /tmp/install-gradle.sh
