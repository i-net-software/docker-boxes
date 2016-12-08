FROM inetsoftware/ubuntu-java-x11
MAINTAINER contact@inetsoftware.de

# Install xvfb as X-Server and x11vnc as VNC-Server
# Also prepare for phantomjs
RUN apt-get update \
    && apt-get install -y --force-yes --no-install-recommends dbus-x11 firefox curl \
    && apt-get install build-essential chrpath libssl-dev libxft-dev -y \
    && apt-get install libfreetype6 libfreetype6-dev -y \
    && apt-get install libfontconfig1 libfontconfig1-dev -y \
    && apt-get autoclean \
    && apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/*

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
RUN mkdir -p /opt/node/node_modules && chown -R jenkins:jenkins /opt/node
RUN apt-get install -y nodejs \
    && apt-get autoclean \
    && apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/*

VOLUME /opt/node/node_modules

COPY install-phantomjs.sh /tmp/
RUN bash /tmp/install-phantomjs.sh && rm /tmp/install-phantomjs.sh

ADD https://ftp.mozilla.org/pub/firefox/releases/46.0.1/linux-x86_64/en-US/firefox-46.0.1.tar.bz2 firefox.tar.bz2
RUN tar -xf firefox.tar.bz2 && mv firefox/ /opt/firefox && mv /usr/bin/firefox /usr/bin/firefox-latest && ln -s /opt/firefox/firefox /usr/bin/firefox
