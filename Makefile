DOCKER_REPO ?= vividboarder
DOCKER_TAG ?= rpi-homebridge
DOCKER_TAG_DEV ?= $(DOCKER_TAG)-dev
HOMEBRIDGE_USER ?= root

.PHONY: default
default: build

# Default target to build the image
.PHONY: build
build:
	docker build -t $(DOCKER_TAG_DEV) .

# Target to build and run and subsequently remove image
.PHONY: run
run: build
	docker run --net=host --rm \
		-p "51826:51826" \
		-v "$(shell pwd)/config.json:/$(HOMEBRIDGE_USER)/.homebridge/config.json" \
		-v "$(shell pwd)/plugins.txt:/$(HOMEBRIDGE_USER)/.homebridge/plugins.txt" \
		$(DOCKER_TAG_DEV)

# Target to drop into an interractive shell
.PHONY: shell
shell: build
	docker run --net=host --rm \
		-p "51826:51826" \
		-v "$(shell pwd)/config.json:/$(HOMEBRIDGE_USER)/.homebridge/config.json" \
		-v "$(shell pwd)/plugins.txt:/$(HOMEBRIDGE_USER)/.homebridge/plugins.txt" \
		$(shell grep -q '^RUN.*cross-build-start' Dockerfile && echo '-v "/usr/bin/qemu-arm-static:/usr/bin/qemu-arm-static"') \
		-it $(DOCKER_TAG_DEV) \
		bash

# Tags dev image so it can be pushed
.PHONY: tag
tag: build
	docker tag $(DOCKER_TAG_DEV) $(DOCKER_REPO)/$(DOCKER_TAG)

# Pushes tagged image to docker hub
.PHONY: push
push: tag
	docker push $(DOCKER_REPO)/$(DOCKER_TAG)


# Clears shrinkwrap so next build will install latest version of everything
.PHONY: unshrinkwrap
unshrinkwrap:
	rm ./npm-shrinkwrap.json
	touch ./npm-shrinkwrap.json

# Generates a new shrinkwrap from installed node modules
.PHONY: shrinkwrap
shrinkwrap: build
	docker run --rm \
		-v "$(shell pwd)/npm-shrinkwrap.json:/homebridge/npm-shrinkwrap-volume.json" \
		$(shell grep -q '^RUN.*cross-build-start' Dockerfile && echo '-v "/usr/bin/qemu-arm-static:/usr/bin/qemu-arm-static"') \
		$(DOCKER_TAG_DEV) \
		bash -c "npm shrinkwrap && cat npm-shrinkwrap.json > npm-shrinkwrap-volume.json"

# Converts Dockerfile so that it can compile on ARM
.PHONY: arm
arm:
	cat Dockerfile | sed '/^RUN.*cross-build-/s/^/# /' > Dockerfile.arm
	mv Dockerfile.arm Dockerfile
