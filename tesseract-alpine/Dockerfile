FROM alpine:3.15 as builder

RUN set -x \
    # Add testing repository
    # && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    # Install SDK
    && apk update \
    && apk upgrade --no-cache apk-tools \
    && apk add --no-cache alpine-sdk \
    # Add user to build with
    && adduser -D -g "User" dev \
    && echo dev:dev | chpasswd \
    && echo "dev ALL=(ALL) ALL" >> /etc/sudoers \
    && echo "dev ALL=NOPASSWD: ALL" >> /etc/sudoers \
    && addgroup dev abuild \
    && mkdir -p /var/cache/distfiles \
    && chmod a+w /var/cache/distfiles

RUN set -x \
    # Add community repository
    # && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    # Install SDK
    && apk update \
    && apk add --no-cache autoconf-archive sudo

# Add the APKBUILD File from
# https://git.alpinelinux.org/cgit/aports/tree/testing/tesseract-git/APKBUILD
ADD APKBUILD /home/dev/APKBUILD

# Add specific Patch files
ADD patches/*.patch /home/dev/

USER dev

ARG SHA
ARG PKGVER
ARG PKGREL
ARG ADDITIONAL_OPTIONS

RUN set -x \
    && cd ~/ \
    # Prepare Environment
    && abuild-keygen -a -i -n \
    && abuild checksum \
    # Build
    && abuild -r

FROM alpine

RUN mkdir -p /tesseract

# Provide the packages in /tesseract folder
# Install using:
# apk add --allow-untrusted /tesseract/teseract-git-*
COPY --from=builder /home/dev/packages/home/x86_64/tesseract-git-* /tesseract/
