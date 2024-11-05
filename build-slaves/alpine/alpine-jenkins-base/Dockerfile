# FROM openjdk:8-jdk-alpine
FROM adoptopenjdk/openjdk8:alpine

LABEL maintainer contact@inetsoftware.de

ARG YQ_VERSION=4.44.3

# Tools
RUN apk add --update --no-cache linux-pam openssh openssl sshpass rsync git subversion bash curl jq sudo
RUN wget https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 -O /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq

# RUN apk add --update --no-cache cyrus-sasl cyrus-sasl-plain cyrus-sasl-digestmd5
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N "" && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N "" && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

# Create User that we can log in with
RUN adduser -D -g "User" jenkins \
    && echo jenkins:jenkins | chpasswd \
    && echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers \
    && echo "UseDNS no >> /etc/ssh/sshd_config"

# jenkins has specific paths to check for java
RUN ln -s $(which java) /usr/bin/java

# Fix some things adopt missed out
# https://github.com/AdoptOpenJDK/openjdk-docker/issues/75
RUN ln -s /lib/libc.musl-x86_64.so.1 /usr/lib/ \
    && printf "export LD_LIBRARY_PATH=/usr/lib\n" | tee -a /etc/profile.d/ld_library_path.sh

# This is also required for non-login access
ENV LD_LIBRARY_PATH=/usr/lib

EXPOSE 22
CMD /usr/sbin/sshd -D
