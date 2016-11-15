# docker-rpi-homebridge
Docker image for running [Homebridge](https://github.com/nfarina/homebridge) on a Raspberry Pi

## Homebridge
Here is what the author has to say about Homebridge:

> Homebridge is a lightweight NodeJS server you can run on your home network that emulates the iOS HomeKit API. It supports Plugins, which are community-contributed modules that provide a basic bridge from HomeKit to various 3rd-party APIs provided by manufacturers of "smart home" devices.

This project is just a Docker container that makes it easy to deploy Homebridge on your Raspberry Pi.

## Getting Docker on your Raspberry Pi
I recommend checking out [Hypriot](http://blog.hypriot.com/) and their [Getting Started](http://blog.hypriot.com/getting-started-with-docker-on-your-arm-device/) guide

## Configuration
There are two files that need to be provided in order for Homebridge to run.

 * `config.json`: For a quick start, you can copy `config-sample.json` and modify it to your needs. For detailed explanation of this file, check out the [documentation](https://github.com/nfarina/homebridge#installation) provided by Homebridge
 * `plugins.txt`: in order to do anything, Homebridge needs to install plugins for your accessories and platforms. You can list them here with each npm package on a new line. See `plugins-sample.txt` for an example and, again, check out the [documentation](https://github.com/nfarina/homebridge#installing-plugins) provided by Homebridge for more details.

## Running
This image is hosted on Docker Hub tagged as [vividboarder/rpi-homebridge](https://hub.docker.com/r/vividboarder/rpi-homebridge/), so you can feel free to use the `docker-compose.yaml` and change `build: .` to `image: vividboarder/rpi-homebridge`. After that, `docker-compose up` should get you started.

Alternately, you can compile the image yourself by cloning this repo and using `docker-compose`

```
docker-compose up
```

If you want a little more control, you can use any of the make targets:

```
make build  # builds a new image
make run    # builds and runs container using same parameters as compose
make shell  # builds and runs an interractive container
make tag    # tags image to be pushed to docker hub
make push   # pushes image to docker hub
```

## Issues?
Feel free to report any issues you're having getting this to run on [Github](https://github.com/ViViDboarder/docker-rpi-homebridge/issues)
