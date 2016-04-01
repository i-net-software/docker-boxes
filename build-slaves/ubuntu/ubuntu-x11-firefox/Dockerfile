FROM inetsoftware/ubuntu-java-x11
MAINTAINER contact@inetsoftware.de

# Install xvfb as X-Server and x11vnc as VNC-Server
RUN apt-get update \
    && apt-get install -y --force-yes --no-install-recommends firefox \
    && apt-get autoclean \
    && apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/* \

RUN apt-get update \
    && apt-get install -y --force-yes \
    build-essential chrpath libssl-dev libxft-dev \
    libfreetype6 libfreetype6-dev \
    libfontconfig1 libfontconfig1-dev \
    && apt-get autoclean \
    && apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/* \

ADD install-phantomjs.sh
RUN install-phantomjs.sh
