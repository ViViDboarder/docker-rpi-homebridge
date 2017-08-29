FROM hypriot/rpi-node:8
MAINTAINER ViViDboarder <vividboarder@gmail.com>

RUN [ "cross-build-start" ]

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get update && \
        apt-get install -y --no-install-recommends \
        avahi-daemon \
        avahi-discover \
        build-essential \
        libavahi-compat-libdnssd-dev \
        libnss-mdns && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
 
RUN apt-get update && apt-get install libpcap-dev iputils-ping

RUN npm config set unsafe-perm true

RUN npm install -g --unsafe-perm \
        homebridge \
        hap-nodejs \
        node-gyp && \
    cd /usr/local/lib/node_modules/homebridge/ && \
    npm install --unsafe-perm bignum && \
    cd /usr/local/lib/node_modules/hap-nodejs/node_modules/mdns && \
    node-gyp BUILDTYPE=Release rebuild

RUN mkdir -p /var/run/dbus/

USER root
RUN mkdir -p /root/.homebridge

RUN [ "cross-build-end" ]

EXPOSE 5353 51826
VOLUME /root/.homebridge
WORKDIR /root/.homebridge

ADD start.sh /root/.homebridge/start.sh

CMD /root/.homebridge/start.sh
