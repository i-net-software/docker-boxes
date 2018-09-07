# escape=`

ARG REGISTRY
FROM ${REGISTRY}inetsoftware/windows-tools

# Reset the shell.
SHELL ["cmd", "/S", "/C"]

# Set up environment to collect install errors.
COPY Install.cmd C:\TEMP\
ADD https://aka.ms/vscollect.exe C:\TEMP\collect.exe

# Install Node.js LTS
#ADD https://nodejs.org/dist/v8.11.3/node-v8.11.3-x64.msi C:\TEMP\node-install.msi
#RUN start /wait msiexec.exe /i C:\TEMP\node-install.msi /l*vx "%TEMP%\MSI-node-install.log" /qn ADDLOCAL=ALL

# Download channel for fixed install.
ARG CHANNEL_URL=https://aka.ms/vs/15/release/channel
ADD ${CHANNEL_URL} C:\TEMP\VisualStudio.chman

# Download and install Build Tools for Visual Studio 2017.
# https://blogs.msdn.microsoft.com/heaths/2018/06/14/no-container-image-for-build-tools-for-visual-studio-2017/
# https://docs.microsoft.com/en-us/visualstudio/install/advanced-build-tools-container
ADD https://aka.ms/vs/15/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe
RUN C:\TEMP\Install.cmd C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --channelUri C:\TEMP\VisualStudio.chman `
    --installChannelUri C:\TEMP\VisualStudio.chman `
    --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools `
    --add Microsoft.Net.Component.3.5.DeveloperTools `
    --add Microsoft.Net.ComponentGroup.4.6.2.DeveloperTools `
    --add Microsoft.Net.ComponentGroup.TargetingPacks.Common `
    --add Microsoft.VisualStudio.Component.TestTools.BuildTools `
    --add Microsoft.VisualStudio.Workload.VCTools `
    --add Microsoft.VisualStudio.Component.VC.140 `
    --add Microsoft.VisualStudio.Component.VC.ATL `
    --add Microsoft.VisualStudio.Component.VC.CLI.Support `
    --add Microsoft.VisualStudio.Component.Windows10SDK.16299.Desktop `
    --add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.WinXP `
#    --add Microsoft.VisualStudio.Workload.NodeBuildTools `
    --add Microsoft.VisualStudio.Component.TypeScript.2.8 `
    --installPath C:\BuildTools


##########################################
# Trying to install the rest
##########################################

# Visual C++ Build Tools - takes very long!
RUN choco install visualcppbuildtools

# Set Environment
RUN @echo off `
    && call "%VS140COMNTOOLS%vsvars32.bat" `
    && set >> C:\environment.properties `
    && @powershell -NoProfile -ExecutionPolicy Bypass -Command " `
        Get-Content C:\environment.properties | Foreach-Object { `
            $key = $_.trim() -replace '(.*?)=(.*)','$1' ; `
            $value = $_.trim() -replace '(.*?)=(.*)','$2' ; `
            setx /m $key \"$value\" ; `
        } `
    " `
    && del C:\environment.properties

# Unit Test Framework to create unit test tools - installed by the testagents already
# RUN nuget install Microsoft.VisualStudio.QualityTools.UnitTestFramework
