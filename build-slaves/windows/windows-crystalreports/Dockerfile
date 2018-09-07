ARG REGISTRY
FROM ${REGISTRY}inetsoftware/windows-sdk
LABEL maintainer contact@inetsoftware.de

#ADD http://fileserver/artifactory/inet-snapshot/lib/CrystalReports/2008/install-cr2008.ps1 /install-cr2008.ps1
ADD http://fileserver/repository/inet-snapshot/lib/CrystalReports/2008/install-cr2008.ps1 /install-cr2008.ps1
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command "C:/install-cr2008.ps1"
