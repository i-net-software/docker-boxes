FROM microsoft/dotnet-framework:4.7.2-sdk
# FROM microsoft/dotnet-framework:4.7.1-sdk
LABEL maintainer contact@inetsoftware.de

# install chocolaty
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# allow global confirmation for choco
RUN choco feature enable -n allowGlobalConfirmation

# add the nuget command line
RUN choco install nuget.commandline

# Reset the shell.
SHELL ["cmd", "/S", "/C"]
