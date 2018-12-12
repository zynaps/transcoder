FROM ubuntu:latest
LABEL maintainer="Igor Vinokurov <zynaps@zynaps.ru>"

RUN \
  set -x && \
  apt-get update -q && apt-get upgrade -y -q && \
  apt-get install --no-install-recommends -y -q software-properties-common && \
  add-apt-repository ppa:stebbins/handbrake-releases && \
  apt-get update -q && \
  apt-get install --no-install-recommends -y -q handbrake-cli

WORKDIR /

COPY transcode.sh ./

VOLUME ["/watch", "/temp", "/deferred", "/output"]

CMD ["/transcode.sh"]
