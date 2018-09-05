FROM inetsoftware/ubuntu-jenkins-base
MAINTAINER contact@inetsoftware.de

ENV TERM xterm
ENV DEBIAN_FRONTEND noninteractive

RUN add-apt-repository ppa:webupd8team/java && \
    add-apt-repository ppa:cwchien/gradle && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

# Java 7
#RUN apt-get update \
#    && apt-get install -y oracle-java7-installer \
#    && apt-get autoclean \
#    && apt-get autoremove \
#    && rm -rf /var/lib/apt/lists/*

# Java 7
# Oracle has removed the sources from their server - at least PPA does not support it any more.
# We're using our own internal now. This will break automatic builds outside of our environment
RUN mkdir -p /var/cache/oracle-jdk7-installer/ \
    && wget -O /var/cache/oracle-jdk7-installer/jdk-7u80-linux-x64.tar.gz http://fileserver/repository/inet-static-libraries/lib/java/7/jdk-7u80-linux-x64.tar.gz \
    && apt-get update \
    && apt-get install -y oracle-java7-installer \
    ; apt-get autoclean \
    ; apt-get autoremove \
    ; rm -rf /var/lib/apt/lists/*

# Java 9
RUN apt-get update \
    && apt-get install -y --no-install-recommends oracle-java9-installer \
    ; apt-get autoclean \
    ; apt-get autoremove \
    ; rm -rf /var/lib/apt/lists/*

# Java 8 + Gradle 4.3.1 (Dafault)
RUN apt-get update \
    && apt-get install -y oracle-java8-installer oracle-java8-set-default \
    && apt-get install -y gradle-4.3.1 \
    && ln -s /usr/lib/jvm/java-8-oracle/jre /usr/lib/jvm/default-java \
    ; apt-get autoclean \
    ; apt-get autoremove \
    ; rm -rf /var/lib/apt/lists/*

# mudraw
RUN apt-get update \
    && apt-get install -y mupdf-tools qpdf \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# MS-TTFonts and dejavu fonts
# Attention: this needs to enable the multiverse repositories
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | /usr/bin/debconf-set-selections \
    && apt-add-repository multiverse \
    && apt-get update \
    && apt-get install -y fontconfig msttcorefonts fonts-dejavu \
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
