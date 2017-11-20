# FROM hypriot/rpi-node:8
FROM node:8
MAINTAINER ViViDboarder <vividboarder@gmail.com>

# RUN [ "cross-build-start" ]

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

RUN mkdir -p /var/run/dbus/

# Can't run as non-root yet because avahi needs to be started by root
# RUN useradd -ms /bin/bash -d /homebridge homebridge
# USER homebridge

RUN mkdir -p /$HOME/.homebridge
VOLUME /$HOME/.homebridge

WORKDIR /homebridge

COPY package.json /homebridge/
COPY npm-shrinkwrap.json /homebridge/

RUN npm install

# RUN [ "cross-build-end" ]

EXPOSE 5353 51826

COPY start.sh /homebridge/

COPY plugins-sample.txt /homebridge/plugins.txt

CMD /homebridge/start.sh
