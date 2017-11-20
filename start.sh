#! /bin/sh

# Fix avahi
sed -i "s/rlimit-nproc=3/#rlimit-nproc=3/" /etc/avahi/avahi-daemon.conf
dbus-daemon --system
avahi-daemon -D
service dbus start
service avahi-daemon start

# Install desired plugins
cat $HOME/.homebridge/plugins.txt | xargs npm install --unsafe-perm

# Start service
/homebridge/node_modules/.bin/homebridge
