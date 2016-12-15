FROM inetsoftware/windows-java-gradle
MAINTAINER contact@inetsoftware.de

# signtool
RUN choco install windows-sdk-8.1

# dev package .NET 4.5.2 - includes msbuild
# RUN choco install netfx-4.5.2-devpack

# Donwload version 1.9 of mutools from their website.
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command " \
    $storageDir = \"C:\tools\" ; \
    $muVersion = \"mupdf-1.10a-windows\" ; \
    $webclient = New-Object System.Net.WebClient ; \
    $url = \"http://www.mupdf.com/downloads/$muVersion.zip\" ; \
    $file = \"$storageDir\mupdf.zip\" ; \
    $webclient.DownloadFile($url,$file) ; \
    Expand-Archive -LiteralPath \"$file\" -DestinationPath \"$storageDir\" ; \
    rm \"$file\" ; \
    SETX Path \"$storageDir\$muVersion\;%PATH%\" \
    ; "

# Ghostscript
RUN choco install ghostscript.app -version 9.20

# Access treiber for mdb
RUN choco install msaccess2010-redist-x64

# ODBC Driver for SQL-Server
RUN choco install sqlserver-odbcdriver

# testing ... things ...
# This is THE ONLY package that allows to install parts of VS to compile our
# SDK/Unit-based samples without installing the whole VS edition.
RUN choco install visualstudio2015testagents

# Unit Test Framework to create unit test tools - installed by the testagents already
# RUN nuget install Microsoft.VisualStudio.QualityTools.UnitTestFramework
