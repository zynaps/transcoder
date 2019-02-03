# TODO: healthcheck

FROM alpine:latest
LABEL maintainer="Igor Vinokurov <zynaps@zynaps.ru>"

RUN \
  set -xe && \
  apk add --no-cache bash inotify-tools && \
  apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing handbrake

WORKDIR /transcode

COPY transcode.sh /

CMD ["bash", "/transcode.sh"]
