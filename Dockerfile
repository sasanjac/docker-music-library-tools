FROM lsiobase/alpine:3.18

LABEL version="0.1.0"
LABEL repository="https://github.com/sasanjac/docker-music-library-tools"

ENV PLEX_URL PLEX_TOKEN

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