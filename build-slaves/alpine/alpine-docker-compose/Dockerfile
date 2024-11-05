FROM ghcr.io/sigstore/cosign/cosign:v2.4.1 as cosign-bin
FROM inetsoftware/alpine-jenkins-base:ssh-docker
LABEL maintainer contact@inetsoftware.de

# Tools
RUN apk add --update --no-cache docker docker-compose

RUN apk add --update --no-cache nodejs npm \
    && npm install -g dockerfile-template

ENV HUBTOOL_VERSION=v0.4.6
ENV PLATFORM=linux-amd64
RUN cd /tmp \
    && curl -fL https://github.com/docker/hub-tool/releases/download/${HUBTOOL_VERSION}/hub-tool-${PLATFORM}.tar.gz -o hub-tool.tgz \
    && tar -xzf hub-tool.tgz \
    && mv ./hub-tool/hub-tool /usr/local/bin/ \
    && rm -rf hub-tool* \
    && cd -

# Install scout and sbom CLI
RUN mkdir -p "/root/.docker/cli-plugins" ; \
    curl -sSfL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh | sh -s -- ; \
    curl -sSfL https://raw.githubusercontent.com/docker/sbom-cli-plugin/main/install.sh | sh -s -- ;

# add cosing
COPY --from=cosign-bin /ko-app/cosign /usr/local/bin/cosign

ADD "start.sh" "start.sh"
ADD "merge-sbom.sh" "/bin/merge-sbom"

ENTRYPOINT [ "/bin/bash", "./start.sh" ]
