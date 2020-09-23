FROM alpine:edge
LABEL maintainer Kenzo Okuda <kyokuheki@gmail.com>

RUN set -x \
 && apk add --no-cache -X https://dl-cdn.alpinelinux.org/alpine/edge/testing \
    openconnect \
    iproute2

ENTRYPOINT ["/usr/bin/openconnect"]
CMD ["--help"]
