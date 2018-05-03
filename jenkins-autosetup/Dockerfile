FROM jenkins/jenkins:lts-alpine
LABEL maintainer contact@inetsoftware.de

######################################################################
# Be root for a moment
######################################################################
USER root

RUN apk update && apk add subversion

######################################################################
# drop back to the regular jenkins user - good practice
######################################################################
USER jenkins

# custom start script
COPY start.sh /usr/local/bin/
COPY 00-managePlugins.groovy "/usr/share/jenkins/ref/init.groovy.d/"

ENTRYPOINT ["/usr/local/bin/start.sh"]
