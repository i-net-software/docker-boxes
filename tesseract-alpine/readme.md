# Alpine Tesseract 4 package builder

This is an alpine container building the tesseract binaries, storing them in a container that can be used to install tesseract in another container. 😳🎉

The motivation is that there is no current version of Tesseract 4 - and it's betas - available as alpine binaries.

To us the binaries in a custom Dockerfile you can do the following:

    FROM inetsoftware/alpine-tesseract as builder

    # dummy builder container

    FROM alpine

    ENV LC_ALL C

    # add required tessdata
    RUN mkdir -p /usr/share/tessdata
    ADD https://github.com/tesseract-ocr/tessdata/raw/master/eng.traineddata /usr/share/tessdata/eng.traineddata
    ADD https://github.com/tesseract-ocr/tessdata/raw/master/deu.traineddata /usr/share/tessdata/deu.traineddata

    # copy the packages
    COPY --from=builder /tesseract/tesseract-git-* /tesseract/

    RUN set -x \
        && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
        && apk add --update --allow-untrusted /tesseract/tesseract-git-* \
        && rm  -rf /tesseract \
        && echo "done"

