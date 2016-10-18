FROM inetsoftware/windows-jenkins-base
MAINTAINER contact@inetsoftware.de

#install git and svn
RUN cyg-get git subversion

# install java
RUN choco install -y jdk8

# install gradle
RUN choco install gradle --version 2.14.1
