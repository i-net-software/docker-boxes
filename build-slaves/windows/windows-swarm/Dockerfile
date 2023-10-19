# escape=`

# See: https://github.com/StefanScherer/dockerfiles-windows/blob/master/swarm/Dockerfile

FROM golang AS build

ENV SWARM_VERSION v1.2.9

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV GIT_VERSION 2.32.0
ENV GIT_DOWNLOAD_URL https://github.com/git-for-windows/git/releases/download/v${GIT_VERSION}.windows.1/MinGit-${GIT_VERSION}-64-bit.zip
ENV GIT_SHA256 e55a73125ea2fd6d1d71470e089a97cf19e6f1c4aaf7c25958d1a9105112a6de

RUN Invoke-WebRequest -UseBasicParsing $env:GIT_DOWNLOAD_URL -OutFile git.zip; `
    if ((Get-FileHash git.zip -Algorithm sha256).Hash -ne $env:GIT_SHA256) {exit 1} ; `
    Expand-Archive -Force git.zip -DestinationPath C:\git; `
    Remove-Item git.zip; `
    Write-Host 'Updating PATH ...'; `
    $env:PATH = 'C:\git\cmd;C:\git\mingw64\bin;C:\git\usr\bin;' + $env:PATH; `
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\' -Name Path -Value $env:PATH

# '

RUN mkdir src\github.com\docker

# Attention: /gopath is the $env:GOPATH
WORKDIR /go/src/github.com/docker

RUN git clone https://github.com/docker/swarm

ENV GO111MODULE=auto

WORKDIR /go/src/github.com/docker/swarm

RUN git checkout $env:SWARM_VERSION

RUN go install .

# NOTE: 1803 is required for Server 19 with Docker 18.03
# NOTE: 1809 is required for Server 19 with Docker 19.03
# NOTE: ltsc2022 is required for Server 2022 with Docker 24.0
FROM mcr.microsoft.com/windows/nanoserver:ltsc2022

COPY --from=build /go/bin/swarm.exe /swarm.exe

ENV SWARM_HOST :2375

EXPOSE 2375

ENTRYPOINT ["\\swarm.exe"]

CMD ["--help"]
