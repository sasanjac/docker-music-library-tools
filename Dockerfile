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
	echo "**** install packages ****" && \
	apk add --no-cache \
		git \
		python3 && \
	python3 -m ensurepip && \
    python3 -m pip install --no-cache-dir --upgrade pip && \
	echo "**** clean up ****" && \
	rm -rf \
		/root/.cache \
		/tmp/*

# add local files
COPY root/ /

# ports and volumes
VOLUME /data/import /data/export_electro /data/export_general /data/todo