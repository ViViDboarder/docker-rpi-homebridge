DOCKER_REPO ?= vividboarder
DOCKER_TAG ?= rpi-homebridge
DOCKER_TAG_DEV ?= $(DOCKER_TAG)-dev
HOMEBRIDGE_USER ?= root

default: build

# Default target to build the image
build:
	docker build -t $(DOCKER_TAG_DEV) .

# Target to build and run and subsequently remove image
run: build
	docker run --net=host --rm \
		-p "51826:51826" \
		-v "$(shell pwd)/config.json:/$(HOMEBRIDGE_USER)/.homebridge/config.json" \
		-v "$(shell pwd)/plugins.txt:/$(HOMEBRIDGE_USER)/.homebridge/plugins.txt" \
		$(DOCKER_TAG_DEV)

# Target to drop into an interractive shell
shell: build
	docker run --net=host --rm \
		-p "51826:51826" \
		-v "$(shell pwd)/config.json:/$(HOMEBRIDGE_USER)/.homebridge/config.json" \
		-v "$(shell pwd)/plugins.txt:/$(HOMEBRIDGE_USER)/.homebridge/plugins.txt" \
		-it $(DOCKER_TAG_DEV) \
		bash

# Tags dev image so it can be pushed
tag: build
	docker tag $(DOCKER_TAG_DEV) $(DOCKER_REPO)/$(DOCKER_TAG)

# Pushes tagged image to docker hub
push: tag
	docker push $(DOCKER_REPO)/$(DOCKER_TAG)


# Clears shrinkwrap so next build will install latest version of everything
unshrinkwrap:
	echo "{}" > ./npm-shrinkwrap.json

# Generates a new shrinkwrap from installed node modules
shrinkwrap: build
	docker run --rm \
		-v "$(shell pwd)/npm-shrinkwrap.json:/homebridge/npm-shrinkwrap-volume.json" \
		$(DOCKER_TAG_DEV) \
		bash -c "npm shrinkwrap && cat npm-shrinkwrap.json > npm-shrinkwrap-volume.json"
