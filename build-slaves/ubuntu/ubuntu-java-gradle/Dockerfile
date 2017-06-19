FROM inetsoftware/ubuntu-jenkins-base
MAINTAINER contact@inetsoftware.de

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
RUN mkdir -p /usr/lib/jvm/ \
    && wget -O- http://fileserver/artifactory/inet-static-libraries/lib/java/7/jdk-7u80-linux-x64.tar.gz | tar xz \
    && wget -O-  http://fileserver/artifactory/inet-static-libraries/lib/java/7/java-7-oracle.jinfo > /usr/lib/jvm/.java-7-oracle.jinfo \
    && mv jdk1.7.0_80 /usr/lib/jvm/java-7-oracle

# Java 9
RUN apt-get update \
    && apt-get install -y oracle-java9-installer \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# Java 8 (Dafault)
RUN apt-get update \
    && apt-get install -y oracle-java8-installer oracle-java8-set-default \
    && apt-get install -y gradle \
    && ln -s /usr/lib/jvm/java-8-oracle/jre /usr/lib/jvm/default-java \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

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
    && apt-get install -y fontconfig ttf-mscorefonts-installer fonts-dejavu \
    && dpkg-reconfigure fontconfig \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# BTW: the problem was not to install the needed fonts, but how to enable them for java. Installing fontconfig solved that.

# Try the docker container to have a syne method set for determining the memory derive by the cgroup limit.
# see https://github.com/jenkinsci/docker/pull/182/commits/50cb8506b0dabc7db8cad66af2f915a3e61b07c4
COPY docker-jvm-opts.sh /usr/local/bin/docker-jvm-opts.sh
RUN echo "export _JAVA_OPTIONS=$(/usr/local/bin/docker-jvm-opts.sh)" | tee -a /home/jenkins/.profile
