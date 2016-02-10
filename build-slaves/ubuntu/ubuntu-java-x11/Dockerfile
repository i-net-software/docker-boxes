FROM inetsoftware/ubuntu-java-gradle
MAINTAINER contact@inetsoftware.de

# Install xvfb as X-Server and x11vnc as VNC-Server
RUN apt-get update && apt-get install -y --no-install-recommends \
				xvfb \
				xauth \
				x11vnc \
				x11-utils \
				x11-xserver-utils \
		&& rm -rf /var/lib/apt/lists/*

# start x11vnc and expose its port
ENV DISPLAY :0.0
EXPOSE 5900