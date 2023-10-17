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
RUN mkdir -p /etc/apt/keyrings \
    && mkdir -p /opt/node/node_modules && chown -R jenkins:jenkins /opt/node \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && NODE_MAJOR=20 \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list  \
    && apt-get update \
    && apt-get install nodejs -y \
    && apt-get autoclean \
    && apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/*

VOLUME /opt/node/node_modules

COPY install-phantomjs.sh /tmp/
RUN bash /tmp/install-phantomjs.sh && rm /tmp/install-phantomjs.sh

# ENV FIREFOX_VERSION=46.0.1
ENV FIREFOX_VERSION=99.0.1
RUN curl -Lso firefox.tar.bz2 https://ftp.mozilla.org/pub/firefox/releases/${FIREFOX_VERSION}/linux-x86_64/en-US/firefox-${FIREFOX_VERSION}.tar.bz2 ; \
    tar -xf firefox.tar.bz2 && mv firefox/ /opt/firefox && mv /usr/bin/firefox /usr/bin/firefox-latest && ln -s /opt/firefox/firefox /usr/bin/firefox && rm firefox.tar.bz2

ENV GECKO_DRIVER=v0.31.0
RUN curl -Lso geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/${GECKO_DRIVER}/geckodriver-${GECKO_DRIVER}-linux64.tar.gz ; \
    tar -xzf geckodriver.tar.gz && chmod +x geckodriver && mv geckodriver /usr/local/bin/ && rm geckodriver.tar.gz
