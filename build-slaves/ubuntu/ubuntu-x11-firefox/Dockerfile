FROM inetsoftware/ubuntu-java-x11
LABEL maintainer contact@inetsoftware.de

# Install xvfb as X-Server and x11vnc as VNC-Server
# Also prepare for phantomjs
RUN apt-get update \
    && apt-get install -y --force-yes --no-install-recommends dbus-x11 firefox curl \
    && apt-get install build-essential chrpath libssl-dev libxft-dev -y \
    && apt-get install libfreetype6 libfreetype6-dev -y \
    && apt-get install libfontconfig1 libfontconfig1-dev -y \
    && apt-get install libasound2 -y \
    && apt-get autoclean \
    && apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/*

# Install nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN mkdir -p /opt/node/node_modules && chown -R jenkins:jenkins /opt/node
RUN apt-get install -y nodejs \
    && apt-get autoclean \
    && apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/*

VOLUME /opt/node/node_modules

COPY install-phantomjs.sh /tmp/
RUN bash /tmp/install-phantomjs.sh && rm /tmp/install-phantomjs.sh

# ENV FIREFOX_VERSION=46.0.1
ENV FIREFOX_VERSION=65.0
ADD https://ftp.mozilla.org/pub/firefox/releases/${FIREFOX_VERSION}/linux-x86_64/en-US/firefox-${FIREFOX_VERSION}.tar.bz2 firefox.tar.bz2
RUN tar -xf firefox.tar.bz2 && mv firefox/ /opt/firefox && mv /usr/bin/firefox /usr/bin/firefox-latest && ln -s /opt/firefox/firefox /usr/bin/firefox && rm firefox.tar.bz2

ENV GECKO_DRIVER=v0.24.0
ADD https://github.com/mozilla/geckodriver/releases/download/${GECKO_DRIVER}/geckodriver-${GECKO_DRIVER}-linux64.tar.gz geckodriver.tar.gz
RUN tar -xzf geckodriver.tar.gz && chmod +x geckodriver && mv geckodriver /usr/local/bin/ && rm geckodriver.tar.gz
