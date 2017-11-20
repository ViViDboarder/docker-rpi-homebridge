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
make build          # builds a new image
make run            # builds and runs container using same parameters as compose
make shell          # builds and runs an interractive container
make tag            # tags image to be pushed to docker hub
make push           # pushes image to docker hub
make unshrinkwrap   # clears npm-shrinkwrap.json so the next build will use latest
make shrinkwrap     # generates npm-shrinkwrap.json to pin versions
make arm            # modifies Dockerfile for building against arm
```

## Multi-arch
This project is capable of being compiled on arm or cross-built on an x86 machine. There is some trickiness involved in this, so here's the description broken down by platform. High level, the `cross-build-start` cannot be present when building on arm. When running the built image, a non-arm system needs to have `qemu-arm-static` mounted as a volume. The `Makefile` tries to automate this a bit.

### arm (Raspberry Pi)
The default is to support building on Docker Hub and not a Raspberry Pi. Unfortunately, `cross-build-start` will fail to run on an arm machine.

To build or shrinkwrap, just add `arm` to your make command. Eg. `make arm build shrinkwrap`. This will modify the `Dockerfile` to comment out the cross-build commands. If contributing changes back upstream, do not commit this change!

### Linux x86
Building can be done by directly running `make build`. If you want to run image, you need to install `qemu qemu-user qemu-user-static`. After that you should be able to run `make shrinkwrap or make shell`.

### macOS
Docker for Mac actually supports running arm binaries. So that's cool! To make things simple, you should follow the arm instructions.

## Development
Follow the instructions above for how to run on your architechture. Also, be sure to not commit commented out `cross-build-*` lines as those are necessary for Docker Hub to build.

### Bumping version numbers
This is most easily done by updating `package.json` and then running `make unshrinkwrap shrinkwrap`. That should force a reinstallation of all node packages and then provide you with an updated `npm-shrinkwrap.json` file to commit.

## Issues?
Feel free to report any issues you're having getting this to run on [Github](https://github.com/ViViDboarder/docker-rpi-homebridge/issues)
