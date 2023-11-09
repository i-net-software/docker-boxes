FROM inetsoftware/fedora-jenkins-base
LABEL maintainer contact@inetsoftware.de

ENV TERM linux
RUN yum install -y wget which rpm-build

COPY install-gradle.sh /tmp
RUN bash /tmp/install-gradle.sh && rm /tmp/install-gradle.sh
