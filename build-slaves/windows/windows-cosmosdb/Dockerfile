ARG REGISTRY
ARG SDK_TAG=latest
FROM ${REGISTRY}inetsoftware/windows-chocolatey:${SDK_TAG}
LABEL maintainer contact@inetsoftware.de

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#This monitor is from Microsoft 
ADD ServiceMonitor.exe /ServiceMonitor.exe

ADD pause.bat /pause.bat

ENV NSSM "http://www.nssm.cc/release/nssm-2.24.zip"
RUN Invoke-WebRequest -UseBasicParsing $env:NSSM -OutFile nssm.zip; \
    Expand-Archive -Force nssm.zip -DestinationPath C:\; \
    Remove-Item nssm.zip; \
    Write-Host 'Updating PATH ...'; \
    $env:PATH = 'C:\nssm-2.24\win64;' + $env:PATH; \
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\' -Name Path -Value $env:PATH; \
    nssm.exe install pause C:\\pause.bat

EXPOSE 10250-10255 10350 8081 8900-8903     

# RUN choco install -y azure-cosmosdb-emulator --version=2.14.12
RUN choco install -y azure-cosmosdb-emulator

ADD profile.ps1 C:/Windows/System32/WindowsPowerShell/v1.0/
ADD Start.ps1 C:/CosmosDB.Emulator/

# run endlessly
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

CMD ["powershell.exe", "-NoExit", "-NoLogo", "-Command", "C:\\CosmosDB.Emulator\\Start.ps1; C:\\ServiceMonitor.exe pause"]
