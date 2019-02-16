# TODO: healthcheck

FROM alpine:latest
LABEL maintainer="Igor Vinokurov <zynaps@zynaps.ru>"

RUN \
  set -xe && \
  apk add --no-cache handbrake --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
  apk add --no-cache bash

WORKDIR /transcode

COPY transcode.sh /

CMD ["bash", "/transcode.sh"]
