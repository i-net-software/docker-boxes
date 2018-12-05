# escape=`

ARG REGISTRY
FROM ${REGISTRY}inetsoftware/windows-java-gradle:sdk

# Visual C++ Build Tools
RUN choco install -y visualcppbuildtools

# Set up environment to collect install errors.
COPY Install.cmd C:\TEMP\
ADD https://aka.ms/vscollect.exe C:\TEMP\collect.exe

# Install Node.js LTS
# ADD https://nodejs.org/dist/v8.11.3/node-v8.11.3-x64.msi C:\TEMP\node-install.msi
# RUN start /wait msiexec.exe /i C:\TEMP\node-install.msi /l*vx "%TEMP%\MSI-node-install.log" /qn ADDLOCAL=ALL

# Download channel for fixed install.
ARG CHANNEL_URL=https://aka.ms/vs/15/release/channel
ADD ${CHANNEL_URL} C:\TEMP\VisualStudio.chman

# Download and install Build Tools for Visual Studio 2017.
# https://github.com/Microsoft/azure-pipelines-image-generation/blob/master/images/win/scripts/Installers/Vs2017/Install-VS2017.ps1
ADD https://aka.ms/vs/15/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe
RUN C:\TEMP\Install.cmd C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --allWorkloads --includeRecommended `
#    --installPath C:\BuildTools `
    --channelUri C:\TEMP\VisualStudio.chman `
    --installChannelUri C:\TEMP\VisualStudio.chman `
#    --add Microsoft.Net.Component.4.7.2.SDK `
    --add Microsoft.Net.Component.4.7.2.TargetingPack `
    --add Microsoft.Net.ComponentGroup.4.7.2.DeveloperTools `
#    --add Microsoft.Net.Component.4.7.SDK `
#    --add Microsoft.Net.Component.4.7.TargetingPack `
#    --add Microsoft.Net.ComponentGroup.4.7.DeveloperTools `
#    --add Microsoft.Net.Component.4.7.1.SDK `
#    --add Microsoft.Net.Component.4.7.1.TargetingPack `
#    --add Microsoft.Net.ComponentGroup.4.7.1.DeveloperTools `
    --add Microsoft.Net.Core.Component.SDK.1x `
    --add Microsoft.NetCore.1x.ComponentGroup.Web `
#    --add Microsoft.VisualStudio.Component.Azure.Storage.AzCopy `
#    --add Microsoft.VisualStudio.Component.PowerShell.Tools `
    --add Microsoft.VisualStudio.Component.VC.140 `
    --add Component.Dotfuscator `
    --add Microsoft.VisualStudio.Component.VC.ATL `
    --add Microsoft.VisualStudio.Component.VC.ATLMFC `
    --add Microsoft.VisualStudio.Component.VC.ClangC2 `
    --add Microsoft.VisualStudio.Component.VC.CLI.Support `
    --add Microsoft.VisualStudio.Component.VC.Modules.x86.x64 `
#    --add Microsoft.VisualStudio.Component.Windows10SDK.10240 `
#    --add Microsoft.VisualStudio.Component.Windows10SDK.10586 `
#    --add Microsoft.VisualStudio.Component.Windows10SDK.14393 `
#    --add Microsoft.VisualStudio.Component.Windows10SDK.15063.Desktop `
#    --add Component.Unreal `
#    --add Component.Unreal.Android `
#    --add Component.Android.SDK23 `
    --add Microsoft.VisualStudio.Component.TestTools.WebLoadTest `
    --add Microsoft.VisualStudio.Web.Mvc4.ComponentGroup `
#    --add Component.CPython2.x64 `
#    --add Microsoft.Component.PythonTools.UWP `
    --add Microsoft.Component.VC.Runtime.OSSupport `
    --add Microsoft.VisualStudio.Component.VC.Tools.ARM `
    --add Microsoft.VisualStudio.ComponentGroup.UWP.VC `
    --add Microsoft.VisualStudio.Component.VSSDK `
#    --add Microsoft.VisualStudio.Component.LinqToSql `
    --add Microsoft.VisualStudio.Component.TestTools.CodedUITest `
    --add Microsoft.VisualStudio.Component.TestTools.Core `
#    --add Microsoft.VisualStudio.Component.TypeScript.2.0 `
#    --add Microsoft.VisualStudio.Component.TypeScript.2.1 `
    --add Microsoft.VisualStudio.Component.TypeScript.2.2 `
#    --add Microsoft.VisualStudio.Component.VC.Tools.ARM64 `
#    --add Microsoft.VisualStudio.Component.Windows10SDK.16299.Desktop.arm `
    --add Microsoft.VisualStudio.Component.DslTools `
#    --add Microsoft.VisualStudio.Component.Windows81SDK `
#    --add Microsoft.VisualStudio.Component.WinXP `
#    --add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Win81 `
#    --add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.WinXP `
    --add Microsoft.VisualStudio.ComponentGroup.ArchitectureTools.Managed `
    --add Microsoft.Component.Blend.SDK.WPF `
    --add Microsoft.VisualStudio.ComponentGroup.TestTools.TestAgent `
    --add Microsoft.Component.MSBuild

# DocFX for documentation
RUN choco install -y docfx