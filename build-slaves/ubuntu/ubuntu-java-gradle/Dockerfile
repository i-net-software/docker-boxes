FROM inetsoftware/ubuntu-jenkins-base
LABEL maintainer contact@inetsoftware.de

ENV TERM xterm
ENV DEBIAN_FRONTEND noninteractive

RUN add-apt-repository ppa:webupd8team/java && \
    add-apt-repository ppa:cwchien/gradle && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

# Java 8 + Gradle 4.10.2 (Default)
RUN apt-get update \
    && apt-get install -y oracle-java8-installer oracle-java8-set-default \
    && apt-get install -y gradle-4.10.2 \
    && ln -s /usr/lib/jvm/java-8-oracle/jre /usr/lib/jvm/default-java \
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

# Hack Gradle. This is needed to inject the actual maximum memory for java processes and be able to set hte JVM_HEAP_RATIO with jenkins
RUN awk 'NR==2{print "echo \"Updating JAVA_TOOL_OPTIONS ...\""}NR==3{print "export JAVA_TOOL_OPTIONS=$(/usr/local/bin/docker-jvm-opts.sh)"}1' $(which gradle) > /tmp/gradle \
    && cat /tmp/gradle > $(which gradle) && rm /tmp/gradle
