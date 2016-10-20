FROM microsoft/windowsservercore
MAINTAINER contact@inetsoftware.de

# install chocolaty
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command "$env:chocolateyUseWindowsCompression = 'false' ; iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex"

# allow global confirmation for choco
RUN choco feature enable -n allowGlobalConfirmation
