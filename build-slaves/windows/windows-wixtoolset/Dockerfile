# escape=`

ARG REGISTRY
FROM ${REGISTRY}inetsoftware/windows-sdk
LABEL maintainer contact@inetsoftware.de

# Spoof 3.5 to be installed, which should be the case since base
RUN powershell -Command "New-Item -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Name 'v3.5' -Force"

# install wixtoolset
RUN choco install -y wixtoolset --version 3.14.1

# install msbuild - already done in dotnet layer
# RUN choco install -y microsoft-build-tools --version 14.0.25420.1

#install NAnt
RUN choco install -y nant --version 0.92.2 --allow-empty-checksums

# This monitor is from Microsoft
# it should already be there but after upgrading the wixtoolset it was gone.
RUN powershell -Command `
#    Add-WindowsFeature Web-Server; `
    Invoke-WebRequest -UseBasicParsing -Uri "https://dotnetbinaries.blob.core.windows.net/servicemonitor/2.0.1.3/ServiceMonitor.exe" -OutFile "C:\ServiceMonitor.exe"
