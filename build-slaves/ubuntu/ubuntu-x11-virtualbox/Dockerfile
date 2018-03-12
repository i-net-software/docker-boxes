FROM inetsoftware/ubuntu-java-x11
LABEL maintainer contact@inetsoftware.de

# Install virtualbox
RUN apt-get update -y \
    && printf "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib\n" | tee -a /etc/apt/sources.list.d/virtualbox.list \
    && apt-get install -y build-essential dkms linux-headers-generic \
    && wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add - \
    && apt-get update \
    && apt-get install -y virtualbox-5.1 \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# Install Extension Pack
RUN VBOX_VERSION=`vboxmanage --version | tail -n 1 | awk -Fr '{print $1}'` \
    && VBOX_FULL_VERSION=`vboxmanage --version | tail -n 1 | awk -Fr '{print $1}'` \
    && wget http://download.virtualbox.org/virtualbox/${VBOX_VERSION}/Oracle_VM_VirtualBox_Extension_Pack-${VBOX_FULL_VERSION}.vbox-extpack \
    && echo y | VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-${VBOX_FULL_VERSION}.vbox-extpack \
    && rm Oracle_VM_VirtualBox_Extension_Pack-${VBOX_FULL_VERSION}.vbox-extpack

RUN mkdir -p /home/jenkins/.config/openbox && echo "x-terminal-emulator &" >> /home/jenkins/.config/openbox/autostart

RUN apt-get update \
    && apt-get install -y xterm \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/*
