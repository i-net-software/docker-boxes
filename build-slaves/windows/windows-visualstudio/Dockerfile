FROM inetsoftware/windows-wixtoolset
MAINTAINER contact@inetsoftware.de

# Visual Studio components seem to bee needed for build certain stuff arround SDK 
RUN choco install visualstudio2015community

# Unit Test Framework to create unit test tools
RUN nuget install Microsoft.VisualStudio.QualityTools.UnitTestFramework
