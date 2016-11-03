FROM jenkins:1.651.3
MAINTAINER contact@inetsoftware.de

######################################################################
# Be root for a moment
######################################################################
USER root

######################################################################
# drop back to the regular jenkins user - good practice
######################################################################
USER jenkins

# custom start script
COPY start.sh /usr/local/bin/
COPY 00-managePlugins.groovy "/usr/share/jenkins/ref/init.groovy.d/"

ENTRYPOINT ["/usr/local/bin/start.sh"]
