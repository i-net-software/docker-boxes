FROM inetsoftware/windows-dotnet
MAINTAINER contact@inetsoftware.de

# testing ... things ...
# This is THE ONLY package that allows to install parts of VS to compile our
# SDK/Unit-based samples without installing the whole VS edition.
RUN choco install visualstudio2015testagents

# Unit Test Framework to create unit test tools - installed by the testagents already
# RUN nuget install Microsoft.VisualStudio.QualityTools.UnitTestFramework
