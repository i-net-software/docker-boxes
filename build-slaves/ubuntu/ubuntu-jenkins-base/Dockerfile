FROM ubuntu:bionic
LABEL maintainer contact@inetsoftware.de

# Install basic components: open ssh, git, svn and PPA abilities.
RUN apt-get update \
    && apt-get install -y software-properties-common apt-transport-https apt-utils \
    && apt-get install -y openssh-server git subversion fakeroot language-pack-en-base sudo \
    && dpkg-reconfigure locales \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd \
    && adduser --quiet --disabled-password --gecos "User" jenkins \
    && echo jenkins:jenkins | chpasswd \
    && echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers \
    && echo "UseDNS no >> /etc/ssh/sshd_config" \
    && echo "PermitUserEnvironment yes >> /etc/ssh/sshd_config"

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:e 
ENV LC_ALL en_US.UTF-8

EXPOSE 22
CMD /usr/sbin/sshd -D -p 22
