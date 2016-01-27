FROM fedora
MAINTAINER contact@inetsoftware.de

# Install OpenSSH Server and rpm build tools
# Create jenkins user and set password

RUN dnf install -y openssh-server auto-buildrequires && \
    mkdir /var/run/sshd && \
    adduser jenkins && \
    echo jenkins:jenkins | chpasswd

CMD /usr/sbin/sshd -D
