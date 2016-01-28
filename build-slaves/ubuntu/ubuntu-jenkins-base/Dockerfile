FROM ubuntu:trusty
MAINTAINER contact@inetsoftware.de

# Install basic components: open ssh, git, svn and PPA abilities.
RUN apt-get update && \
    apt-get install -y software-properties-common python-software-properties && \
    apt-get install -y openssh-server git subversion && \
    mkdir /var/run/sshd && \
    adduser --quiet --disabled-password --gecos "User" jenkins && \
    echo jenkins:jenkins | chpasswd

CMD /usr/sbin/sshd -D
