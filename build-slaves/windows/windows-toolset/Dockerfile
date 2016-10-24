FROM inetsoftware/windows-java-gradle
MAINTAINER contact@inetsoftware.de

# Donwload version 1.9 of mutools from their website.
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command " \
    $storageDir = \"C:\tools\" ; \
    $muVersion = \"mupdf-1.9a-windows\" ; \
    $webclient = New-Object System.Net.WebClient ; \
    $url = \"http://www.mupdf.com/downloads/$muVersion.zip\" ; \
    $file = \"$storageDir\mupdf.zip\" ; \
    $webclient.DownloadFile($url,$file) ; \
    Expand-Archive -LiteralPath \"$file\" -DestinationPath \"$storageDir\" ; \
    rm \"$file\" ; \
    SETX Path \"$storageDir\$muVersion\;%PATH%\" \
    ; "
