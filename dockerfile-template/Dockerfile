FROM jkilbride/node-npm-alpine:6

LABEL maintainer "i-net software <contact@inetsoftware.de>"

RUN npm install -g dockerfile-template

RUN mkdir /templates

WORKDIR /templates

ENTRYPOINT dockerfile-template
