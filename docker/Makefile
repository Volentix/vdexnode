PROJECT_NAME = volentix
PROJECT_PATH ?= $(shell pwd)
NETWORK_NAME = volentix
SERVER_NAME = vdexnode

clean:
	docker rm -f vdexnode

build:
	docker build -t vdexnode . --no-cache=true

push:
	docker push volentix/vdexnode

network:
	docker network create $(NETWORK_NAME)

run-server-dockerhub:
	docker run -d --name $(SERVER_NAME) --network $(NETWORK_NAME) \
	-e "IP=${IP}" -e "EOSKEY=${EOSKEY}" \
	-p 8000:8000 -p 4222:4222/udp volentix/vdexnode:latest server

run-server:
	docker run -d --name $(SERVER_NAME) --network $(NETWORK_NAME) \
	-e "IP=${IP}" -e "EOSKEY=${EOSKEY}" \
	-p 8000:8000 -p 4222:4222/udp vdexnode server


run-key_gen:
	docker run --rm -ti --network $(NETWORK_NAME) -v config:/volentix/config:z \
	-v ${PROJECT_PATH}/client_data:/volentix/client_data:z \
	volentix/node key_gen http://$(SERVER_NAME):8000 /volentix/client_data/$(client).key

run-sign:
	docker run --rm -ti --network $(NETWORK_NAME) -v config:/volentix/config:z \
	-v ${PROJECT_PATH}/client_data:/volentix/client_data:z \
	volentix/node sign http://$(SERVER_NAME):8000 /volentix/client_data/$(client).key '$(msg)'

attach-server:
	docker exec -ti vdexnode bash

%:
	@:
