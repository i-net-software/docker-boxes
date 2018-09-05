FROM inetsoftware/ubuntu-java-gradle
LABEL maintainer contact@inetsoftware.de

ENV DEBIAN_FRONTEND noninteractive

# https://github.com/tesseract-shadow/tesseract-ocr-re/blob/master/Dockerfile
RUN add-apt-repository -y ppa:alex-p/tesseract-ocr && \
    apt-get update && \
    apt-get install -y tesseract-ocr-all
