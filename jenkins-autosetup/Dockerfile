FROM jenkins
MAINTAINER contact@inetsoftware.de

######################################################################
# Be root for a moment
######################################################################
USER root

# Setup the PPA capability
RUN apt-get update \
    && apt-get install -y software-properties-common python-software-properties \
    && add-apt-repository ppa:cwchien/gradle

# Install gradle
RUN apt-get update && apt-get install -y gradle \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

######################################################################
# drop back to the regular jenkins user - good practice
######################################################################
USER jenkins

# custom start script
COPY start.sh /usr/local/bin/
COPY 00-managePlugins.groovy "/usr/share/jenkins/ref/init.groovy.d/"

ENTRYPOINT ["/usr/local/bin/start.sh"]
