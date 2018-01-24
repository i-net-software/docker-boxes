FROM microsoft/dotnet-framework:3.5
LABEL maintainer contact@inetsoftware.de

# install chocolaty
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command "$env:chocolateyUseWindowsCompression = 'false' ; iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex"

# allow global confirmation for choco
RUN choco feature enable -n allowGlobalConfirmation

# add the nuget command line
RUN choco install nuget.commandline
