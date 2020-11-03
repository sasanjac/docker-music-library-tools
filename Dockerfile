ARG FROM_ARCH=amd64

# Multi-stage build, see https://docs.docker.com/develop/develop-images/multistage-build/
FROM alpine AS builder

# Download QEMU, see https://github.com/ckulka/docker-multi-arch-example
ADD https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz .
RUN tar zxvf qemu-3.0.0+resin-arm.tar.gz --strip-components 1
ADD https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz .
RUN tar zxvf qemu-3.0.0+resin-aarch64.tar.gz --strip-components 1


FROM lsiobase/alpine:$FROM_ARCH-3.12

LABEL version="0.0.1"
LABEL repository="https://github.com/sasanjac/docker-music-library-tools"

# Add QEMU
COPY --from=builder qemu-arm-static /usr/bin
COPY --from=builder qemu-aarch64-static /usr/bin

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies --update \
	gcc \
	build-base \
	python3-dev \
	libffi-dev \
	openssl-dev \
	git && \
 echo "**** install packages ****" && \
 apk add --no-cache --update python3 && \
 python3 -m ensurepip && \
 pip3 install --upgrade pip && \
 pip3 install poetry && \
 echo "**** clean up ****" && \
 rm -rf \
	/root/.cache \
	/tmp/*

RUN poetry config virtualenvs.in-project true

# add local files
COPY root/ /

# ports and volumes
VOLUME /data/import /data/export_electro /data/export_general /data/todo