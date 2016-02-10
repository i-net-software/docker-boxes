FROM inetsoftware/ubuntu-jenkins-base
MAINTAINER contact@inetsoftware.de

RUN add-apt-repository ppa:webupd8team/java && \
    add-apt-repository ppa:cwchien/gradle && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

RUN apt-get update && apt-get install -y oracle-java8-installer gradle oracle-java8-set-default \
    && ln -s /usr/lib/jvm/java-8-oracle/jre /usr/lib/jvm/default-java \
    && rm -rf /var/lib/apt/lists/*
