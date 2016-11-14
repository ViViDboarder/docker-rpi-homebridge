build:
	docker build -t rpi-homebridge .

run: build
	docker run --net=host --rm \
		-v "$(shell pwd)/config.json:/root/.homebridge/config.json" \
		-v "$(shell pwd)/plugins.txt:/root/.homebridge/plugins.txt" \
		rpi-homebridge

shell: build
	docker run --net=host --rm \
		-v "$(shell pwd)/config.json:/root/.homebridge/config.json" \
		-v "$(shell pwd)/plugins.txt:/root/.homebridge/plugins.txt" \
		-it rpi-homebridge bash
