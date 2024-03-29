# https://github.com/Microsoft/dotnet-framework-docker/tree/master/4.7.2/sdk/windowsservercore-ltsc2016
# It says that there are the 4.7.2 sdks as well.
# and we need it for the vs2015 container
ARG SDK_TAG=latest
# FROM microsoft/dotnet-framework:3.5${SDK_TAG}

# Install the Fonts from a generic 3rd party image. They are missing in the current windowsservercore images
FROM inetsoftware/windows-fonts as FONTS_BASE

# CAREFUL!!! THIS IS A PSEUDO TAG, DEFINED BY build.env
FROM mcr.microsoft.com/dotnet/framework:3.5${SDK_TAG}


# FROM microsoft/dotnet-framework:3.5-sdk
# FROM microsoft/dotnet-framework:4.7.2-sdk
# FROM microsoft/dotnet-framework:4.7.1-sdk
LABEL maintainer contact@inetsoftware.de

SHELL ["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

# install chocolaty. We're using a very old version due to the requirement of .NET 3.5 in our build system
RUN $env:chocolateyVersion = '0.10.15' ; Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# allow global confirmation for choco
RUN choco feature enable -n allowGlobalConfirmation

# Disable download progress bar
RUN choco feature disable -n=showDownloadProgress

# add the nuget command line
RUN choco install nuget.commandline

# Install .Net 4.6 for later use
RUN  choco install netfx-4.6-devpack

# Install newer version. We have to stay on 1.4 due to .NET 4.8 not being available for our windowsservercore image
RUN choco upgrade chocolatey --version 1.4.0

# Reset the shell.
SHELL ["cmd", "/S", "/C"]

# Add the Fonts
COPY --from=FONTS_BASE /Fonts /Windows/fonts
ADD LoadFonts.ps1 /

RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command "C:\LoadFonts.ps1"
