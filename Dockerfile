FROM lsiobase/alpine:3.12

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