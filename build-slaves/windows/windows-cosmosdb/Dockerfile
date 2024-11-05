FROM mcr.microsoft.com/cosmosdb/winsrv2019/azure-cosmos-emulator:latest

ENTRYPOINT [ "powershell", "-NoExit", "-NoLogo" ]

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#This monitor is from Microsoft 
ADD ServiceMonitor.exe /ServiceMonitor.exe
RUN true

ADD pause.bat /pause.bat

ENV NSSM "http://www.nssm.cc/release/nssm-2.24.zip"
RUN Invoke-WebRequest -UseBasicParsing $env:NSSM -OutFile nssm.zip; \
    Expand-Archive -Force nssm.zip -DestinationPath C:\; \
    Remove-Item nssm.zip; \
    Write-Host 'Updating PATH ...'; \
    $env:PATH = 'C:\nssm-2.24\win64;' + $env:PATH; \
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\' -Name Path -Value $env:PATH; \
    nssm.exe install pause C:\\pause.bat

# run endlessly
CMD ["powershell", "-Command", "C:\\CosmosDB.Emulator\\Start.ps1; C:\\ServiceMonitor.exe pause"]
