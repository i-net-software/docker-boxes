FROM jenkins
MAINTAINER contact@inetsoftware.de

# custom start script
COPY start.sh /usr/local/bin/

######################################################################
# Be root for a moment
######################################################################
USER root

# More stuff

######################################################################
# drop back to the regular jenkins user - good practice
######################################################################
USER jenkins

ENTRYPOINT ["/usr/local/bin/start.sh"]
