FROM inetsoftware/ubuntu-java-gradle
LABEL maintainer contact@inetsoftware.de

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# Install xvfb as X-Server and x11vnc as VNC-Server
RUN apt-get update \
    && apt-get install -y --force-yes --no-install-recommends \
            supervisor \
            openbox xvfb xterm \
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
    && mkdir ~/.vnc \
    && mkdir -p /home/jenkins/.config/openbox && echo "x-terminal-emulator &" >> /home/jenkins/.config/openbox/autostart

ADD supervisord.conf /etc/supervisor/conf.d/

ENV DISPLAY_RESOLUTION="1200x800"

EXPOSE 5900 22

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
