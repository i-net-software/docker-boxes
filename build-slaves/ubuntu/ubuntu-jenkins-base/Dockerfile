FROM ubuntu:trusty
MAINTAINER contact@inetsoftware.de

RUN apt-get update && \
    apt-get install -y software-properties-common python-software-properties && \
    apt-get install -y openssh-server && \
    mkdir /var/run/sshd && \
    adduser --quiet --disabled-password --gecos "User" jenkins && \
    echo jenkins:jenkins | chpasswd

CMD /usr/sbin/sshd -D
