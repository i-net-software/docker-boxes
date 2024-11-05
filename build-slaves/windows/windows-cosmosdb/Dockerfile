ARG REGISTRY
ARG SDK_TAG=latest
FROM ${REGISTRY}inetsoftware/windows-chocolatey:${SDK_TAG}
LABEL maintainer contact@inetsoftware.de

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

EXPOSE 10250-10255 10350 8081 8900-8903

# RUN choco install -y azure-cosmosdb-emulator
RUN choco install -y azure-cosmosdb-emulator --version=2.14.18

ADD profile.ps1 C:/Windows/System32/WindowsPowerShell/v1.0/
ADD Start.ps1 C:/CosmosDB.Emulator/

ENTRYPOINT ["powershell.exe", "-NoExit", "-NoLogo", "-Command", "C:\\CosmosDB.Emulator\\Start.ps1"]
