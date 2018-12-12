FROM ubuntu:latest
LABEL maintainer="Igor Vinokurov <zynaps@zynaps.ru>"

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y software-properties-common && \
  add-apt-repository ppa:stebbins/handbrake-releases && \
  apt-get update && \
  apt-get install --no-install-recommends -y handbrake-cli

WORKDIR /

COPY transcode.sh ./

VOLUME ["/watch", "/temp", "/deferred", "/output"]

CMD ["/transcode.sh"]
