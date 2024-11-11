ARG REGISTRY
ARG SDK_TAG=latest
FROM ${REGISTRY}inetsoftware/windows-jenkins-base:${SDK_TAG}
LABEL maintainer contact@inetsoftware.de

#install git
RUN choco install -y git

#install svn - tortoisesvn because svn package is broken
RUN choco install -y tortoisesvn

# install java
RUN choco install -y jdk11 -params "both=true"

# install gradle
RUN choco install gradle --version 4.10.3

# Jenkins will call a gradle.bat file
ADD gradle.bat /Windows/System32/gradle.bat
# RUN move C:/gradle.bat C:/Windows/System32/gradle.bat

# VIM
RUN choco install vim-tux
