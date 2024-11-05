# dummy 

FROM inetsoftware/alpine-java-gradle
LABEL maintainer contact@inetsoftware.de

ENV LC_ALL C

RUN mkdir -p /usr/share/tessdata
ADD [   "https://github.com/tesseract-ocr/tessdata/raw/main/eng.traineddata", \
        "https://github.com/tesseract-ocr/tessdata/raw/main/deu.traineddata", \
        "/usr/share/tessdata/" \
    ]

RUN set -x \
    && apk add --update tesseract-ocr
