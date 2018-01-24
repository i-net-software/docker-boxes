FROM inetsoftware/windows-java-gradle
LABEL maintainer contact@inetsoftware.de


# signtool - see sdk
# RUN choco install windows-sdk-8.1

# dev package .NET 4.5.2 - includes msbuild
# RUN choco install netfx-4.5.2-devpack

# Donwload version 1.9 of mutools from their website.
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command " \
    $progressPreference = 'silentlyContinue' ; \
    $storageDir = \"C:\tools\" ; \
    $url = \"https://www.mupdf.com/downloads\" ; \
    $r=iwr $url -UseBasicParsing ; \
    $l=$r.Links |?{$_.href -match \"windows.zip\"} | select \"href\" | select -last 1 ; \
    $muVersion=$l.href.substring(0, $l.href.length -4) ; \
    $file = \"$storageDir\mupdf.zip\" ; \
    mkdir $storageDir; \
    echo \"Loading: '$url/$muVersion.zip' to: $file\" ; \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    ((New-Object System.Net.WebClient).DownloadFile(\"$url/$muVersion.zip\", \"$file\")) ; \
    Expand-Archive -LiteralPath \"$file\" -DestinationPath \"$storageDir\" ; \
    rm \"$file\" ; \
    SETX Path \"$storageDir\$muVersion\;%PATH%\" \
    ; "

# Ghostscript
RUN choco install ghostscript.app -version 9.20
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command " \
    $gs=dir \"$env:ProgramFiles\gs\" | select Name ;\
    SETX Path ( \"$env:ProgramFiles\gs\\\" + ($gs | select -ExpandProperty \"Name\" ) + \"\bin;%PATH%\") ; \
    $env:path=( \"$env:ProgramFiles\gs\\\" + ($gs | select -ExpandProperty \"Name\" ) + \"\bin;$env:path\") ; \
    ;"

# Access treiber for mdb
RUN choco install msaccess2010-redist-x64

# ODBC Driver for SQL-Server
RUN choco install sqlserver-odbcdriver

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
