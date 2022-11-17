#sudo docker build -t inkscape:<version> .
FROM ghcr.io/linuxserver/baseimage-rdesktop-web:jammy

# set version label
ARG BUILD_DATE="17-NOV-2022"
ARG VERSION="0.0.7"
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="harmanhobbit"

RUN \
 echo "**** get packages ****" && \
 sudo apt-get update && \
# sudo apt-get upgrade -y && \
 sudo apt-get install -y inkscape
 
# add local files
COPY /root /

# ports and volumes
EXPOSE 3000
VOLUME /config
