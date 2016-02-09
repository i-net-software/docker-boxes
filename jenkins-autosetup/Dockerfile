FROM jenkins
MAINTAINER contact@inetsoftware.de

######################################################################
# Be root for a moment
######################################################################
USER root

# More stuff
# RUN apt-get update && apt-get install -y vim

######################################################################
# drop back to the regular jenkins user - good practice
######################################################################
USER jenkins

# custom start script
COPY start.sh /usr/local/bin/
COPY managePlugins.groovy "$JENKINS_HOME/jobs/"

ENTRYPOINT ["/usr/local/bin/start.sh"]