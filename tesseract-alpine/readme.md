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
    ADD https://github.com/tesseract-ocr/tessdata/raw/main/eng.traineddata /usr/share/tessdata/eng.traineddata
    ADD https://github.com/tesseract-ocr/tessdata/raw/main/deu.traineddata /usr/share/tessdata/deu.traineddata

    # copy the packages
    COPY --from=builder /tesseract/tesseract-git-* /tesseract/

    RUN set -x \
        && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
        && apk add --update --allow-untrusted /tesseract/tesseract-git-* \
        && rm  -rf /tesseract \
        && echo "done"

## Available builds and tags

  * tesseract master: `inetsoftware/alpine-tesseract:master` `inetsoftware/alpine-tesseract:latest`
  * tesseract 4.1.0: `inetsoftware/alpine-tesseract:4.1.0`
  * tesseract 4.0.0: `inetsoftware/alpine-tesseract:4.0.0` `inetsoftware/alpine-tesseract:4.0.0-tess4j`
  * tesseract beta 4: `inetsoftware/alpine-tesseract:4.0.0-beta4` `inetsoftware/alpine-tesseract:4.0.0-beta4-tess4j`

**Note**: The tess4j build omits libgomp as per [this GitHub issue](https://github.com/tesseract-ocr/tesseract/issues/1860).

**Note**: As per version 4.1.0 omitting libgomp is default and we do not need separated images anymore.
