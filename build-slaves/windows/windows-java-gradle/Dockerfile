FROM inetsoftware/windows-jenkins-base
MAINTAINER contact@inetsoftware.de

#install git
RUN choco install -y git

#install svn
RUN choco install -y svn

# install java
RUN choco install -y jdk8 -params "both=true"

# install gradle
RUN choco install gradle --version 3.3

# Jenkins will call a gradle.bat file
ADD gradle.bat /Windows/System32/gradle.bat
# RUN move C:/gradle.bat C:/Windows/System32/gradle.bat
