FROM inetsoftware/ubuntu-java-gradle
MAINTAINER contact@inetsoftware.de

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# Install xvfb as X-Server and x11vnc as VNC-Server
RUN apt-get update \
    && apt-get install -y --force-yes --no-install-recommends \
                supervisor \
				openbox xvfb \
				x11vnc \
				x11-utils \
				x11-xserver-utils \
                gtk2-engines-murrine \
                ttf-ubuntu-font-family \
                imagemagick \
                ghostscript \
        && apt-get autoclean \
        && apt-get autoremove \
		&& rm -rf /var/lib/apt/lists/* \
		&& mkdir ~/.vnc

ADD supervisord.conf /etc/supervisor/conf.d/

EXPOSE 5900 22
ENTRYPOINT /usr/bin/supervisord -n
