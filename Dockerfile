FROM hypriot/rpi-node:7
# FROM hypriot/rpi-node:6.9.1
MAINTAINER ViViDboarder <vividboarder@gmail.com>

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
        build-essential \
        avahi-daemon \
        avahi-discover \
        libnss-mdns \
        libavahi-compat-libdnssd-dev

RUN npm install -g --unsafe-perm \
        homebridge \
        hap-nodejs \
        node-gyp && \
    cd /usr/local/lib/node_modules/homebridge/ && \
    npm install --unsafe-perm bignum && \
    cd /usr/local/lib/node_modules/hap-nodejs/node_modules/mdns && \
    node-gyp BUILDTYPE=Release rebuild

USER root
RUN mkdir -p /root/.homebridge
VOLUME /root/.homebridge
WORKDIR /root/.homebridge

EXPOSE 5353 51826

CMD cat /root/.homebridge/plugins.txt | xargs npm install -g --unsafe-perm && homebridge
