FROM inetsoftware/ubuntu-java-x11
MAINTAINER contact@inetsoftware.de

# Install xvfb as X-Server and x11vnc as VNC-Server
RUN apt-get update \
    && apt-get install -y --force-yes --no-install-recommends firefox \
    && apt-get autoclean \
    && apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/* \

ADD install-phantomjs.sh
RUN install-phantomjs.sh
