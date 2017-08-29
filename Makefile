default: build

# Default target to build the image
build:
	docker build -t rpi-homebridge-dev .

# Target to build and run and subsequently remove image
run: build
	docker run --net=host --rm \
		-p "51826:51826" \
		-v "$(shell pwd)/config.json:/root/.homebridge/config.json" \
		-v "$(shell pwd)/plugins.txt:/root/.homebridge/plugins.txt" \
		rpi-homebridge-dev

# Target to drop into an interractive shell
shell: build
	docker run --net=host --rm \
		-p "51826:51826" \
		-v "$(shell pwd)/config.json:/root/.homebridge/config.json" \
		-v "$(shell pwd)/plugins.txt:/root/.homebridge/plugins.txt" \
		-it rpi-homebridge-dev bash

# Tags dev image so it can be pushed
tag: build
	docker tag rpi-homebridge-dev vividboarder/rpi-homebridge

# Pushes tagged image to docker hub
push: tag
	docker push vividboarder/rpi-homebridge

clean-shrinkwrap:
	echo '{}' > npm-shrinkwrap.json

update-shrinkwrap: clean-shrinkwrap build
	docker run --rm \
		-v "$(shell pwd)/npm-shrinkwrap.json:/homebridge/npm-shrinkwrap.json" \
		rpi-homebridge-dev npm shrinkwrap
		# rpi-homebridge-dev cp package-lock.json npm-shrinkwrap.json
