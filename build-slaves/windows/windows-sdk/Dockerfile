ARG REGISTRY
FROM ${REGISTRY}inetsoftware/windows-vs-2015
LABEL maintainer contact@inetsoftware.de

# INSTALLS THE WINDOWS 10.1 SDK
# https://github.com/coderobin/windows-container/blob/master/windowsservercore/windows-sdk-10.1/Dockerfile
RUN powershell -Command \
    mkdir c:\install_logs; \
    Invoke-WebRequest https://coderobin.blob.core.windows.net/public/fakenet/x64/FakeNet.exe -OutFile $env:temp\fakenet64.exe; \
    Invoke-WebRequest https://coderobin.blob.core.windows.net/public/fakenet/x86/FakeNet.exe -OutFile $env:temp\fakenet.exe; \
    Copy C:\Windows\System32\net.exe C:\Windows\System32\net.exe.bak; \
    Copy C:\Windows\SysWOW64\net.exe C:\Windows\SysWOW64\net.exe.bak; \
    $acl1 = Get-Acl C:\Windows\System32\net.exe; \
    $acl11 = Get-Acl C:\Windows\System32\net.exe; \
    $acl2 = Get-Acl C:\Windows\SysWOW64\net.exe; \
    $acl21 = Get-Acl C:\Windows\SysWOW64\net.exe; \
    $permission = 'BUILTIN\Administrators','FullControl','Allow'; \
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission; \
    $acl11.SetAccessRule($accessRule); \
    Set-Acl C:\Windows\System32\net.exe -AclObject $acl11; \
    $acl21.SetAccessRule($accessRule); \
    Set-Acl C:\Windows\SysWOW64\net.exe -AclObject $acl21; \
    Copy $env:temp\fakenet64.exe C:\Windows\System32\net.exe; \
    Copy $env:temp\fakenet.exe C:\Windows\SysWOW64\net.exe; \
    wget http://download.microsoft.com/download/2/1/2/2122BA8F-7EA6-4784-9195-A8CFB7E7388E/StandaloneSDK/sdksetup.exe -OutFile sdksetup.exe; \
    Start-Process -FilePath "C:\sdksetup.exe" -ArgumentList /Quiet, /NoRestart, /Log, c:\install_logs\sdksetup.log -PassThru -Wait; \
    rm sdksetup.exe; \
    Remove-Item C:\Windows\System32\net.exe; \
    Remove-Item C:\Windows\SysWOW64\net.exe; \
    Rename-Item C:\Windows\System32\net.exe.bak C:\Windows\System32\net.exe; \
    Rename-Item C:\Windows\SysWOW64\net.exe.bak C:\Windows\SysWOW64\net.exe; \
    Set-Acl C:\Windows\System32\net.exe -AclObject $acl1; \
    Set-Acl C:\Windows\SysWOW64\net.exe -AclObject $acl2;

# The Build Tools/NuGet are required for our Process Bridge Setup
RUN powershell -Command \
    wget https://coderobin.blob.core.windows.net/public/Microsoft/BuildTools_MSBuildNuGet.zip -OutFile BuildTools_MSBuildNuGet.zip; \
    Expand-Archive -Path BuildTools_MSBuildNuGet.zip -DestinationPath /; \
    Start-Process -FilePath msiexec.exe -ArgumentList /i, "C:\BuildTools_MSBuildNuGet\BuildTools_MSBuildNuGet.msi", /qn, /L, BuildTools_MSBuildNuGet.install.log -PassThru -Wait; \
    rm BuildTools_MSBuildNuGet.zip; \
    rm -Recurse -Force BuildTools_MSBuildNuGet;
