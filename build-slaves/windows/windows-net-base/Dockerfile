# https://github.com/Microsoft/dotnet-framework-docker/tree/master/4.7.2/sdk/windowsservercore-ltsc2016
# It says that there are the 4.7.2 sdks as well.
# and we need it for the vs2015 container
ARG SDK_TAG=latest
# FROM microsoft/dotnet-framework:3.5${SDK_TAG}

# CAREFUL!!! THIS IS A PSEUDO TAG, DEFINED BY build.env
FROM mcr.microsoft.com/dotnet/framework:3.5${SDK_TAG}

LABEL maintainer contact@inetsoftware.de

SHELL ["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

RUN Set-Service -Name wuauserv -StartupType Manual; Start-Service wuauserv ; \
    Install-WindowsFeature -Name NET-Framework-Core ; \
    Stop-Service wuauserv; Set-Service -Name wuauserv -StartupType Disabled
