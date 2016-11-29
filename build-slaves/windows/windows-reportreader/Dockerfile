FROM inetsoftware/windows-sdk

# SDK 6.0 for .NET 3.5 and 2.0. Implies 7zip. About 1.2GB Download!
# Changed:not needed due to windows-sdk-image having the windows-sdk-8.0 already  
# RUN choco install --allow-empty-checksums windows-sdk-6.0 

# Visual C++ 2005 SP1 installation
RUN choco install vcredist2005

# Visual C++ 2005 Redist ATL Update
ADD https://download.microsoft.com/download/6/B/B/6BB661D6-A8AE-4819-B79F-236472F6070C/vcredist_x86.exe /vcredist_x86_atl.exe
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process 'C:/vcredist_x86_atl.exe' -ArgumentList '/Q'  -Wait -WindowStyle Hidden -PassThru ; del C:/vcredist_x86_atl.exe"

############################################################################################################################################################################################
# Crystal Reports for VisualStudio.
# Includes the olegdl.dll because the docker container is no GUI based image it lacks this file.
# see https://social.technet.microsoft.com/Forums/windowsserver/en-US/7055c7a6-8f84-4b2d-83d3-49bc9d9273e8/oledlgdll-missing-in-server-core-vs-2012-dependency?forum=winservercore
# see https://msdn.microsoft.com/en-us/library/ms723876.aspx?f=255&MSPPError=-2147217396
#
ADD http://fileserver/artifactory/inet-snapshot/lib/CrystalReports//13.0.4/install-cr4vs.ps1 /install-cr4vs.ps1
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command "C:/install-cr4vs.ps1 ; del C:/install-cr4vs.ps1"
