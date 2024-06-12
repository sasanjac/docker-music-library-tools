FROM ghcr.io/linuxserver/baseimage-alpine:3.20

LABEL repository="https://github.com/sasanjac/docker-music-library-tools"

RUN \
	echo "**** install packages ****" && \
	apk add --no-cache \
	git \
	python3 \
	py3-pip && \
	echo "**** clean up ****" && \
	rm -rf \
	/root/.cache \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
VOLUME /data/import /data/export_electro /data/export_general /data/todo