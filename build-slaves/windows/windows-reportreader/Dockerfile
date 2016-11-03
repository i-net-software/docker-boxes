FROM inetsoftware/windows-sdk

ADD http://fileserver/artifactory/inet-snapshot/lib/CrystalReports//13.0.4/install-cr4vs.ps1 /install-cr4vs.ps1
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command "C:/install-cr4vs.ps1"
