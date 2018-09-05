ARG REGISTRY
FROM ${REGISTRY}inetsoftware/windows-sdk
LABEL maintainer contact@inetsoftware.de

# install wixtoolset
RUN choco install -y wixtoolset --version 3.10.2.2516

# install msbuild - already done in dotnet layer
# RUN choco install -y microsoft-build-tools --version 14.0.25420.1

#install NAnt
RUN choco install -y nant --version 0.92.1
