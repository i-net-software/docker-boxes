FROM inetsoftware/alpine-java-gradle
LABEL maintainer contact@inetsoftware.de

RUN set -x && \
  apk add --update --no-cache tesseract-ocr && \
  # download traineddata
  # english
  # wget -q -P /usr/share/tessdata/ https://github.com/tesseract-ocr/tessdata/raw/master/eng.traineddata && \
  # japanese
  # wget -q -P /usr/share/tessdata/ https://github.com/tesseract-ocr/tessdata/raw/master/jpn.traineddata && \
  # enable to use hocr option
  # wget -q -P /usr/share/tessdata/ https://github.com/tesseract-ocr/tessdata/raw/master/osd.traineddata && \
  echo "Done."
