# escape=`

# See: https://github.com/StefanScherer/dockerfiles-windows/blob/master/swarm/Dockerfile

FROM golang AS build

ENV SWARM_VERSION v1.2.9

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV GIT_VERSION 2.22.0
ENV GIT_DOWNLOAD_URL https://github.com/git-for-windows/git/releases/download/v${GIT_VERSION}.windows.1/MinGit-${GIT_VERSION}-64-bit.zip
ENV GIT_SHA256 308ce95b7de5792bed9d56e1af5d2053052ea6347ea0021f74070056684ce3ee

RUN Invoke-WebRequest -UseBasicParsing $env:GIT_DOWNLOAD_URL -OutFile git.zip; `
    if ((Get-FileHash git.zip -Algorithm sha256).Hash -ne $env:GIT_SHA256) {exit 1} ; `
    Expand-Archive -Force git.zip -DestinationPath C:\git; `
    Remove-Item git.zip; `
    Write-Host 'Updating PATH ...'; `
    $env:PATH = 'C:\git\cmd;C:\git\mingw64\bin;C:\git\usr\bin;' + $env:PATH; `
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\' -Name Path -Value $env:PATH

# '

RUN mkdir src\github.com\docker

WORKDIR /go/src/github.com/docker

RUN git clone https://github.com/docker/swarm

WORKDIR /go/src/github.com/docker/swarm

RUN git checkout $env:SWARM_VERSION

RUN go install .

# NOTE: 1803 is required for Server 19 with Docker 18.03
FROM mcr.microsoft.com/windows/nanoserver:1803

COPY --from=build /go/bin/swarm.exe /swarm.exe

ENV SWARM_HOST :2375

EXPOSE 2375

ENTRYPOINT ["\\swarm.exe"]

CMD ["--help"]
