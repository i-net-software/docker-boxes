FROM inetsoftware/alpine-tesseract as builder

# dummy 

FROM inetsoftware/alpine-java-gradle
LABEL maintainer contact@inetsoftware.de

COPY --from=builder /tesseract/tesseract-git-* /tesseract/

RUN set -x \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk update \
    && apk add --allow-untrusted /tesseract/tesseract-git-* \
    && rm  -rf /tesseract \
    && echo "done"
