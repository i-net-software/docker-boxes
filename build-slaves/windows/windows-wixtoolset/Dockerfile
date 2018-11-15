# escape=`

ARG REGISTRY
FROM ${REGISTRY}inetsoftware/windows-sdk
LABEL maintainer contact@inetsoftware.de

# install wixtoolset
RUN choco install -y wixtoolset --version 3.11.1

# install msbuild - already done in dotnet layer
# RUN choco install -y microsoft-build-tools --version 14.0.25420.1

#install NAnt
RUN choco install -y nant --version 0.92.1

# This monitor is from Microsoft
# it should already be there but after upgrading the wixtoolset it was gone.
RUN powershell -Command `
#    Add-WindowsFeature Web-Server; `
    Invoke-WebRequest -UseBasicParsing -Uri "https://dotnetbinaries.blob.core.windows.net/servicemonitor/2.0.1.3/ServiceMonitor.exe" -OutFile "C:\ServiceMonitor.exe"
