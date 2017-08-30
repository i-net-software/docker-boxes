FROM inetsoftware/ubuntu-java-x11
MAINTAINER contact@inetsoftware.de

RUN apt-get update && apt-get install -y libgtk2.0-0 libcanberra-gtk-module libxext-dev libxrender-dev libxtst-dev

RUN wget http://eclipse.c3sl.ufpr.br/technology/epp/downloads/release/oxygen/R/eclipse-java-oxygen-R-linux-gtk-x86_64.tar.gz -O /tmp/eclipse.tar.gz -q && \
    echo 'Installing eclipse' && \
    tar -xf /tmp/eclipse.tar.gz -C /opt && \
    rm /tmp/eclipse.tar.gz

ENV DISPLAY_RESOLUTION="1920x1080"

ADD run.sh /usr/local/bin/eclipse
ADD eclipse.conf /etc/supervisor/conf.d/

RUN chmod +x /usr/local/bin/eclipse && \
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/jenkins && \
    chmod 0440 /etc/sudoers.d/jenkins && \
    chown jenkins:jenkins -R /home/jenkins && \
    chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo
