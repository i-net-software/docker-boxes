FROM inetsoftware/ubuntu-java-gradle
LABEL maintainer contact@inetsoftware.de

RUN wget https://packages.microsoft.com/config/$(. /etc/os-release; echo "$ID")/$(. /etc/os-release; echo "$VERSION_ID")/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt update \
    && apt install -y apt-transport-https dotnet-runtime-6.0 \
    && dpkg -r packages-microsoft-prod \
    && apt update
