FROM adoptopenjdk:8-jdk-hotspot-bionic as JAVA

# Register Image as copy source for Java 8

FROM inetsoftware/ubuntu-jenkins-base
LABEL maintainer contact@inetsoftware.de

ENV TERM xterm
ENV DEBIAN_FRONTEND noninteractive

# Java 8
COPY --from=JAVA /opt/java/openjdk /opt/java/openjdk
ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"

# The link is required for jenkins to start the VM
RUN mkdir -p /usr/java \
    && ln -s ${JAVA_HOME}/jre /usr/java/default \
    && ln -s ${JAVA_HOME}/bin/java /usr/local/bin \
    && ln -s ${JAVA_HOME}/bin/javac /usr/local/bin

# Gradle 4.10.2 (Default)
RUN add-apt-repository ppa:cwchien/gradle \
    && apt-get update \
    && apt-get install -y gradle-4.10.3 \
    ; apt-get autoclean \
    ; apt-get autoremove \
    ; rm -rf /var/lib/apt/lists/*

# mudraw
RUN apt-get update \
    && apt-get install -y mupdf-tools qpdf curl \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# MS-TTFonts and dejavu fonts
# Attention: this needs to enable the multiverse repositories
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | /usr/bin/debconf-set-selections \
    && apt-add-repository multiverse \
    && apt-get update \
    && apt-get install -y fontconfig ttf-mscorefonts-installer fonts-dejavu \
    && dpkg-reconfigure fontconfig \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# BTW: the problem was not to install the needed fonts, but how to enable them for java. Installing fontconfig solved that.

# Try the docker container to have a syne method set for determining the memory derive by the cgroup limit.
# see https://github.com/jenkinsci/docker/pull/182/commits/50cb8506b0dabc7db8cad66af2f915a3e61b07c4
COPY docker-jvm-opts.sh /usr/local/bin/docker-jvm-opts.sh

# Hack Gradle. This is needed to inject the actual maximum memory for java processes and be able to set the JVM_HEAP_RATIO with jenkins
RUN awk 'NR==2{print "echo \"Updating JAVA_TOOL_OPTIONS ...\""}NR==3{print "export JAVA_TOOL_OPTIONS=$(/usr/local/bin/docker-jvm-opts.sh)"}1' $(which gradle) > /tmp/gradle \
    && cat /tmp/gradle > $(which gradle) && rm /tmp/gradle

# Add JAVA_HOME to profile.d
RUN printf "export JAVA_HOME=${JAVA_HOME}\nexport PATH=\$JAVA_HOME/bin:\$PATH:/bin" > /etc/profile.d/java-env.sh
