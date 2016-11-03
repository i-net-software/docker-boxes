FROM inetsoftware/windows-sdk
MAINTAINER contact@inetsoftware.de

ADD http://fileserver/artifactory/inet-snapshot/CrystalReport/2008/install-cr2008.ps1 /install-cr2008.ps1
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command "C:/install-cr2008.ps1"
