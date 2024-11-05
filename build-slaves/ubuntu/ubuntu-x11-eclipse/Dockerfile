# FROM adoptopenjdk:11-jre-hotspot-bionic as JAVA

FROM inetsoftware/ubuntu-java-x11
LABEL maintainer contact@inetsoftware.de

# RUN mv /opt/java/openjdk /opt/java/openjdk8

# Java 11
# COPY --from=JAVA /opt/java/openjdk /opt/java/openjdk

RUN apt-get update \
    && apt-get install -y libgtk-3-0 libcanberra-gtk-module libxext-dev libxrender-dev libxtst-dev \
    && apt-get autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

ENV BASE_URL http://eclipse.c3sl.ufpr.br/technology/epp/downloads/release
RUN set -x ; \
    RELEASE=$(wget -qO- "${BASE_URL}/release.xml" | grep present | sed -e 's/<[^>]*>//g') ; \
    RELEASE_NAME=${RELEASE%%/*} ; \
    RELEASE_VERSION=${RELEASE##*/} ; \
    wget http://eclipse.c3sl.ufpr.br/technology/epp/downloads/release/${RELEASE}/eclipse-java-${RELEASE_NAME}-${RELEASE_VERSION}-linux-gtk-x86_64.tar.gz -O /tmp/eclipse.tar.gz -q && \
    echo 'Installing eclipse' && \
    tar -xf /tmp/eclipse.tar.gz -C /opt && \
    rm /tmp/eclipse.tar.gz

ENV DISPLAY_RESOLUTION="1920x1080"

ADD run.sh /usr/local/bin/eclipse
RUN true
ADD eclipse.conf /etc/supervisor/conf.d/
RUN true

RUN chmod +x /usr/local/bin/eclipse && \
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/jenkins && \
    chmod 0440 /etc/sudoers.d/jenkins && \
    chown jenkins:jenkins -R /home/jenkins && \
    chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo
