# escape=`

ARG REGISTRY
FROM ${REGISTRY}inetsoftware/windows-java-gradle:sdk

# Visual Studio 2019 TestAgent
RUN choco install -y visualstudio2019testagent

# Visual C++ Build Tools
RUN choco install visualstudio2019buildtools

# Set up environment to collect install errors.
COPY Install.cmd C:\TEMP\
ADD https://aka.ms/vscollect.exe C:\TEMP\collect.exe

# Download and install Build Tools for Visual Studio 2017.
# https://github.com/Microsoft/azure-pipelines-image-generation/blob/master/images/win/scripts/Installers/Vs2017/Install-VS2017.ps1
# https://github.com/microsoft/azure-pipelines-image-generation/blob/master/images/win/scripts/Installers/WindowsContainer1803/Install-VS2017-BuildTools.ps1
# https://github.com/actions/virtual-environments/blob/master/images/win/scripts/Installers/Windows2016/Install-VS2017.ps1
# https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container?view=vs-2019
ADD https://aka.ms/vs/16/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe
RUN C:\TEMP\Install.cmd C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --allWorkloads --includeRecommended `
#    --installPath C:\BuildTools `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 `
    --remove Microsoft.VisualStudio.Component.Windows81SDK `
#    --add Microsoft.Net.Component.4.7.2.SDK `
    --addProductLang en-US

# DocFX for documentation
RUN choco install -y docfx
