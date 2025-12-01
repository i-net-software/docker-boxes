FROM eclipse-temurin:25-jdk-ubi10-minimal
LABEL maintainer contact@inetsoftware.de

# Install OpenSSH Server, rpm build tools, git and subversion
# Create jenkins user and set password
RUN microdnf update && microdnf install -y dnf
RUN dnf install -y openssh-server git subversion langpacks-en unzip wget && \
    mkdir /var/run/sshd

# Install auto-buildrequires and ensure rpm-sign functionality
# Note: rpm-sign functionality is provided by rpmsign command in rpm package (already available)
# For auto-buildrequires, try downloading RPM from Fedora Koji
RUN dnf install -y rpm-build python3-pip python3-setuptools || true
RUN (python3 -m pip install --break-system-packages auto-buildrequires 2>&1 || \
     (wget -q "https://kojipkgs.fedoraproject.org/packages/auto-buildrequires/0.4.0/3.fc40/noarch/auto-buildrequires-0.4.0-3.fc40.noarch.rpm" -O /tmp/auto-buildrequires.rpm 2>&1 && \
      rpm -ivh /tmp/auto-buildrequires.rpm --nodeps --force 2>&1 || true) || \
     echo "Note: auto-buildrequires may need manual installation") && \
    rm -f /tmp/*.rpm 2>/dev/null || true

RUN adduser jenkins && \
    echo jenkins:jenkins | chpasswd && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N "" && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N "" && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N "" && \
    echo "UseDNS no >> /etc/ssh/sshd_config" && \
    mkdir -p /etc/sudoers.d/ && \
    echo "jenkins	ALL=(ALL) 	NOPASSWD: ALL"  >> /etc/sudoers.d/jenkins


EXPOSE 22
CMD /usr/sbin/sshd -D -p 22
