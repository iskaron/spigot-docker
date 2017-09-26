FROM openjdk:jdk-alpine
MAINTAINER Oliver Meyer <mail@iskaron.de>

RUN apk update && apk add ca-certificates wget && update-ca-certificates && apk upgrade && \
    apk add --no-cache bash git openssh

ENV MINECRAFT_VERSION=1.12.2

RUN mkdir /build /minecraft /data && cd /build && \
	wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar && \
	java -jar BuildTools.jar --rev $MINECRAFT_VERSION && \
	cp spigot-$MINECRAFT_VERSION.jar /minecraft/spigot.jar && \
	cd /minecraft && rm -rf /build

RUN /usr/sbin/useradd -s /bin/bash -d /minecraft -m minecraft && \
	chown -R minecraft /minecraft /data

RUN apk remove git openssh

EXPOSE 25566/tcp
EXPOSE 8123/tcp

USER minecraft
ADD docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT /docker-entrypoint.sh

