default: build

# Default target to build the image
build:
	docker build -t rpi-homebridge-dev .

clean:
	-docker kill homebridge
	-docker rm homebridge

# Target to build and run and subsequently remove image
run: build
	docker run --net=host --rm \
		-p "51826:51826" \
		-v "$(shell pwd)/config.json:/root/.homebridge/config.json" \
		-v "$(shell pwd)/plugins.txt:/root/.homebridge/plugins.txt" \
		-v "$(shell pwd)/persist:/root/.homebridge/persist" \
		rpi-homebridge-dev

# Target to drop into an interractive shell
shell: build
	docker run --net=host --rm \
		-p "51826:51826" \
		-v "$(shell pwd)/config.json:/root/.homebridge/config.json" \
		-v "$(shell pwd)/plugins.txt:/root/.homebridge/plugins.txt" \
		-v "$(shell pwd)/persist:/root/.homebridge/persist" \
		-it rpi-homebridge-dev bash

# Target to buld and run in detached mode (continuously)
go: build
	make clean
	docker run --net=host -d \
		-p "51826:51826" \
		-v "$(shell pwd)/config.json:/root/.homebridge/config.json" \
		-v "$(shell pwd)/plugins.txt:/root/.homebridge/plugins.txt" \
		-v "$(shell pwd)/persist:/root/.homebridge/persist" \
		--name homebridge \
		rpi-homebridge-dev

# Tags dev image so it can be pushed
tag: build
	docker tag rpi-homebridge-dev vividboarder/rpi-homebridge

# Pushes tagged image to docker hub
push: tag
	docker push vividboarder/rpi-homebridge
