FROM inetsoftware/windows-jenkins-base
MAINTAINER contact@inetsoftware.de

#install git and svn
RUN cyg-get git subversion

# install java
RUN choco install -y jdk8 -params "both=true"

# install gradle
RUN choco install gradle --version 2.14.1

# Jenkins will call a gradle.bat file
ADD gradle.bat /gradle.bat
RUN cp C:/gradle.bat C:/Windows/System32/gradle.bat
