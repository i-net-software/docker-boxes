ARG REGISTRY
FROM ${REGISTRY}inetsoftware/windows-tools

# testing ... things ...
# This is THE ONLY package that allows to install parts of VS to compile our
# SDK/Unit-based samples without installing the whole VS edition.
RUN choco install visualstudio2015testagents

# Visual C++ Build Tools - takes very long!
# https://community.chocolatey.org/packages/microsoft-build-tools/14.0.25420.1
RUN choco install microsoft-build-tools --version=14.0.25420.1

# Set up environment to collect install errors.
COPY Install.cmd C:/TEMP/
ADD https://aka.ms/vscollect.exe C:/TEMP/collect.exe

# http://disq.us/p/2gqaah0
ADD https://aka.ms/vs/15/release/vs_buildtools.exe C:/TEMP/vs_buildtools.exe
RUN C:/TEMP/Install.cmd C:/TEMP/vs_buildtools.exe --quiet --wait --norestart --nocache \
    --add Microsoft.VisualStudio.Workload.MSBuildTools \
    --add Microsoft.VisualStudio.Workload.VCTools \
    --add Microsoft.VisualStudio.Component.Windows81SDK \
    --add Microsoft.VisualStudio.Component.VC.140 \
    --add Microsoft.Component.VC.Runtime.UCRTSDK

# Set Environment
RUN @echo off \
    && call "%VS140COMNTOOLS%\vsvars32.bat" \
    && set >> C:\environment.properties \ 
    && @powershell -NoProfile -ExecutionPolicy Bypass -Command " \
        Get-Content C:\environment.properties | Foreach-Object { \
            $key = $_.trim() -replace '(.*?)=(.*)','$1' ; \
            $value = $_.trim() -replace '(.*?)=(.*)','$2' ; \
            [Environment]::SetEnvironmentVariable("$($key)", "$($value)",'Machine'); \
        } \
    " \
    && del C:\environment.properties
