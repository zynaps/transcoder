# TODO: switch to alpine:latest
# TODO: healthcheck

FROM alpine:edge
LABEL maintainer="Igor Vinokurov <zynaps@zynaps.ru>"

RUN \
  set -xe && \
  apk add --no-cache bash inotify-tools && \
  apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing handbrake

WORKDIR /

COPY . ./

VOLUME ["/watch", "/temp", "/deferred", "/output"]

CMD ["bash", "transcode.sh"]
