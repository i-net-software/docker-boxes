FROM inetsoftware/ubuntu-java-gradle
LABEL maintainer contact@inetsoftware.de

RUN wget https://packages.microsoft.com/config/$(. /etc/os-release; echo "$ID")/$(. /etc/os-release; echo "$VERSION_ID")/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt update \
    # Install dotnet runtime 6 for our older packages that needs building
    # Install the dotnet sdk 8 so that it can be used for docfx
    && apt install -y apt-transport-https dotnet-runtime-6.0 dotnet-sdk-8.0 \
    && dpkg -r packages-microsoft-prod \
    && apt update

# Install docfx
RUN mkdir -p /usr/share/dotnet-tools \
    && dotnet tool install docfx --tool-path /usr/share/dotnet-tools

# Add ~/.dotnet/tools to PATH so docfx is available
RUN echo "PATH=\"${PATH}:/usr/share/dotnet-tools\"" > /etc/environment
ENV PATH="${PATH}:/usr/share/dotnet-tools"

# Install mono
# if there are other dependencies required, check
# https://www.mono-project.com/download/stable/
#
RUN apt install ca-certificates gnupg \
&& gpg --homedir /tmp --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/mono-official-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
&& chmod +r /usr/share/keyrings/mono-official-archive-keyring.gpg \
&& echo "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list \
&& apt update \
&& apt install -y mono-complete mono-devel referenceassemblies-pcl

# Manually install .NET 5.0 SDK (no longer in standard repos)
# Download and extract .NET 5.0 SDK to support net50 target framework
# Note: .NET SDKs can coexist in /usr/share/dotnet, so we extract into the existing directory
RUN DOTNET_VERSION=5.0.408 \
    && wget -q https://dotnetcli.azureedge.net/dotnet/Sdk/${DOTNET_VERSION}/dotnet-sdk-${DOTNET_VERSION}-linux-x64.tar.gz \
    && tar -zxf dotnet-sdk-${DOTNET_VERSION}-linux-x64.tar.gz -C /usr/share/dotnet \
    && rm dotnet-sdk-${DOTNET_VERSION}-linux-x64.tar.gz

# Do not send telemetry
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

# Verify installations
RUN dotnet --list-runtimes \
    && dotnet tool list -g \
    && mono --version
