FROM inetsoftware/windows-java-gradle
MAINTAINER contact@inetsoftware.de

# dev package .NET 4.5.2 - includes msbuild
RUN choco install netfx-4.5.2-devpack

# Unit Test Framework to create unit test tools
RUN nuget install Microsoft.VisualStudio.QualityTools.UnitTestFramework
