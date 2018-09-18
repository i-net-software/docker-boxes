ARG REGISTRY
FROM ${REGISTRY}inetsoftware/windows-tools

# testing ... things ...
# This is THE ONLY package that allows to install parts of VS to compile our
# SDK/Unit-based samples without installing the whole VS edition.
RUN choco install visualstudio2015testagents

# Visual C++ Build Tools - takes very long!
RUN choco install visualcppbuildtools

# Set Environment
RUN @echo off \
    && call "%VS140COMNTOOLS%vsvars32.bat" \
    && set >> C:\environment.properties \ 
    && @powershell -NoProfile -ExecutionPolicy Bypass -Command " \
        Get-Content C:\environment.properties | Foreach-Object { \
            $key = $_.trim() -replace '(.*?)=(.*)','$1' ; \
            $value = $_.trim() -replace '(.*?)=(.*)','$2' ; \
            setx /m $key \"$value\" ; \
        } \
    " \
    && del C:\environment.properties

# Unit Test Framework to create unit test tools - installed by the testagents already
# RUN nuget install Microsoft.VisualStudio.QualityTools.UnitTestFramework