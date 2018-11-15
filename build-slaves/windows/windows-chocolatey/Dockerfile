# https://github.com/Microsoft/dotnet-framework-docker/tree/master/4.7.2/sdk/windowsservercore-ltsc2016
# It says that there are the 4.7.2 sdks as well.
# and we need it for the vs2015 container
FROM microsoft/dotnet-framework:3.5
# FROM microsoft/dotnet-framework:4.7.2-sdk
# FROM microsoft/dotnet-framework:4.7.1-sdk
LABEL maintainer contact@inetsoftware.de

SHELL ["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

# install chocolaty
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# allow global confirmation for choco
RUN choco feature enable -n allowGlobalConfirmation

# add the nuget command line
RUN choco install nuget.commandline

# Reset the shell.
SHELL ["cmd", "/S", "/C"]
