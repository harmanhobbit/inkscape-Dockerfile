#sudo docker build --no-cache -t puredata:<version> .
FROM ghcr.io/linuxserver/baseimage-rdesktop-web:jammy

# set version label
ARG BUILD_DATE="17-NOV-2022"
ARG VERSION="0.0.6"
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="harmanhobbit"

RUN \
 echo "**** get packages ****" && \
 sudo apt-get update && \
# sudo apt-get upgrade -y && \
 sudo apt-get install -y wget unzip nano && \
 sudo mkdir inkscape && cd inkscape && \
 sudo wget https://gitlab.com/inkscape/inkscape/-/jobs/artifacts/1.2.x/download?job=inkscape%3Alinux && \
 sudo mv 'download?job=inkscape:linux' inkscape && \
 sudo unzip inkscape
 
RUN \
 echo "**** fix version number ****" &&\
 sudo dpkg-deb -R inkscape-*.deb inkscape && \
 sudo sed -i 's/0.0.2-$/0.0.2-1/;s/all$/amd64/;s/java$/libs/' && \
 sudo dpkg-deb -b inkscape .
# cd build
# sudo mv inkscape-*.deb inkscape.deb


FROM ghcr.io/linuxserver/baseimage-rdesktop-web:jammy

COPY --from=0 /inkscape/build/inkscape.deb ./

RUN \
 sudo apt-get update && \
# sudo apt-get upgrade -y && \
 sudo dpkg -i inkscape*.deb && \
 sudo rm inkscape*.deb

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000
VOLUME /config
