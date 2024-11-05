ARG BASE=inetsoftware/alpine-java-base

FROM ${BASE}

ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="/opt/java/openjdk/bin:$PATH"

# jenkins has specific paths to check for java
RUN ln -s $(which java) /usr/bin/java

# Tools
RUN apk add --update --no-cache linux-pam openssh openssl sshpass rsync git subversion bash curl jq yq sudo
# RUN apk add --update --no-cache cyrus-sasl cyrus-sasl-plain cyrus-sasl-digestmd5
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N "" && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N "" && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

# Create User that we can log in with
RUN adduser -D -g "User" jenkins \
    && echo jenkins:jenkins | chpasswd \
    && echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers \
    && echo "UseDNS no >> /etc/ssh/sshd_config"

EXPOSE 22
CMD /usr/sbin/sshd -D
