FROM debian:jessie
MAINTAINER wovka88 <wovka@icloud.com>

VOLUME ["/var/lib/unifi", "/var/log/unifi", "/var/run/unifi", "/usr/lib/unifi/work"]

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://www.ubnt.com/downloads/unifi/debian unifi5 ubiquiti" > /etc/apt/sources.list.d/20ubiquiti.list && \
  echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.4 main" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50 && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6

RUN apt-get -q update && \
  apt-get install -qy --force-yes --no-install-recommends unifi && \
  apt-get -q clean && \
  rm -rf /var/lib/apt/lists/*

RUN ln -s /var/lib/unifi /usr/lib/unifi/data
EXPOSE 6789/tcp 8080/tcp 8081/tcp 8443/tcp 8843/tcp 8880/tcp 3478/udp

WORKDIR /var/lib/unifi

ENTRYPOINT ["/usr/bin/java", "-Xmx1024M", "-jar", "/usr/lib/unifi/lib/ace.jar"]
CMD ["start"]
