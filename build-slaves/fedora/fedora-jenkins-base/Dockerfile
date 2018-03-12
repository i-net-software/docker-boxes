FROM fedora
LABEL maintainer contact@inetsoftware.de

# Install OpenSSH Server, rpm build tools, git and subversion
# Create jenkins user and set password
RUN dnf updateinfo && dnf install -y openssh-server auto-buildrequires git subversion && \
    mkdir /var/run/sshd && \
    adduser jenkins && \
    echo jenkins:jenkins | chpasswd && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N "" && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N "" && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N "" && \
    echo "UseDNS no >> /etc/ssh/sshd_config"

EXPOSE 22
CMD /usr/sbin/sshd -D -p 22
