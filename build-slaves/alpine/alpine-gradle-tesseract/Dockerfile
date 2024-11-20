FROM inetsoftware/alpine-tesseract:4.1.1 as builder
# dummy 

FROM inetsoftware/alpine-java-gradle
LABEL maintainer contact@inetsoftware.de

ENV LC_ALL C

RUN mkdir -p /usr/share/tessdata
ADD [   "https://github.com/tesseract-ocr/tessdata/raw/main/eng.traineddata", \
        "https://github.com/tesseract-ocr/tessdata/raw/main/deu.traineddata", \
        "/usr/share/tessdata/" \
    ]

COPY --from=builder /tesseract/tesseract-git-4.* /tesseract/

RUN set -x \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/v3.15/community" >> /etc/apk/repositories \
    && apk add --update --allow-untrusted /tesseract/tesseract-git-* \
    && cd /usr/lib/ && ln -s libtesseract.so.4.0.0 libtesseract.so && cd -\
    && rm  -rf /tesseract \
    && echo "done"
