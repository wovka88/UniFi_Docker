FROM ubuntu:16.10
MAINTAINER wovka88 <wovka@icloud.com>

VOLUME ["/var/lib/unifi", "/var/log/unifi", "/var/run/unifi"]

ENV DEBIAN_FRONTEND noninteractive

ENV UNIFIURL=https://www.ubnt.com/downloads/unifi/5.5.8-f7e54e94a4/unifi_sysvinit_all.deb

RUN echo "deb http://www.ubnt.com/downloads/unifi/debian unifi5 ubiquiti" > /etc/apt/sources.list.d/20ubiquiti.list && \
  echo "deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen" > /etc/apt/sources.list.d/mongodb.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50 && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10

RUN apt-get -q update && apt-get install -qy --force-yes --no-install-recommends curl mongodb-org-server binutils jsvc && \
  curl --insecure -L ${UNIFIURL} -o /tmp/unifi_sysvinit_all.deb && \
  dpkg -i /tmp/unifi_sysvinit_all.deb || /bin/true && apt-get -yf --force-yes install && \
  apt-get -q clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN apt-get -q update && \
#  apt-get install -qy --force-yes --no-install-recommends unifi && \
#  apt-get -q clean && \
#  rm -rf /var/lib/apt/lists/*

RUN ln -s /var/lib/unifi /usr/lib/unifi/data
EXPOSE 6789/tcp 8080/tcp 8081/tcp 8443/tcp 8843/tcp 8880/tcp 3478/udp

WORKDIR /var/lib/unifi

ENTRYPOINT ["/usr/bin/java", "-Xmx1024M", "-jar", "/usr/lib/unifi/lib/ace.jar"]
CMD ["start"]
