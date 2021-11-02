ARG REGISTRY
FROM ${REGISTRY}inetsoftware/windows-java-gradle
LABEL maintainer contact@inetsoftware.de

# Reset the shell.
SHELL ["powershell.exe", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

# MuPDF
RUN choco install mupdf --version 1.19.0

# Ghostscript
RUN choco install ghostscript.app --version 9.52
RUN $gs=dir $env:ProgramFiles/gs | select Name | select -ExpandProperty Name ; \
    echo 'GS: ' $gs ; \
    SETX Path $env:ProgramFiles\gs\$gs\bin';%PATH%' \
    ;

SHELL ["cmd", "/S", "/C"]

# Access treiber for mdb
RUN choco install msaccess2010-redist-x64

# ODBC Driver for SQL-Server
RUN choco install sqlserver-odbcdriver
