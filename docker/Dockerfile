FROM ubuntu:16.04

RUN apt-get update && apt-get install -y build-essential cmake git wget libncurses5-dev libreadline-dev nettle-dev libgnutls28-dev libuv1-dev cython3 python3-dev libcppunit-dev libjsoncpp-dev libasio-dev libssl-dev python3-setuptools openssl python3-pip curl && apt-get clean

# build restbed from sources
RUN git clone --recursive https://github.com/corvusoft/restbed.git \
	&& cd restbed && mkdir build && cd build \
	&& cmake -DBUILD_TESTS=NO -DBUILD_EXAMPLES=NO -DBUILD_SSL=NO -DBUILD_SHARED=YES -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib .. \
	&& make -j8 install \
	&& cd .. && rm -rf restbed

#build msgpack from source
RUN wget https://github.com/msgpack/msgpack-c/releases/download/cpp-2.1.5/msgpack-2.1.5.tar.gz \
	&& tar -xzf msgpack-2.1.5.tar.gz \
	&& cd msgpack-2.1.5 && mkdir build && cd build \
	&& cmake -DMSGPACK_CXX11=ON -DMSGPACK_BUILD_EXAMPLES=OFF -DCMAKE_INSTALL_PREFIX=/usr .. \
	&& make -j8 && make install \
	&& cd ../.. && rm -rf msgpack-2.1.5 msgpack-2.1.5.tar.gz

#build opendht
RUN git clone --recursive https://github.com/savoirfairelinux/opendht.git \
	&& cd opendht && sed -i 's/config.dht_config.node_config.maintain_storage = false/config.dht_config.node_config.maintain_storage = true/g' ./tools/dhtnode.cpp \
	&& sed -i 's/bool permanent = false/bool permanent = true/g' ./include/opendht/dht_proxy_client.h \ 
	&& sed -i 's/bool permanent = false/bool permanent = true/g' ./include/opendht/securedht.h \
	&& mkdir build && cd build \
	&& cmake -DCMAKE_INSTALL_PREFIX=/usr -DOPENDHT_PYTHON=On -DOPENDHT_LTO=On -DOPENDHT_TESTS=ON -DOPENDHT_PROXY_SERVER=ON -DOPENDHT_PROXY_SERVER_IDENTITY=ON ..  \
	&& make -j8 && ./opendht_unit_tests && make install

#create dir for node keys
RUN mkdir /volentix

EXPOSE 9080/tcp
EXPOSE 8100/tcp
EXPOSE 4222/udp

COPY ./api /api
RUN cd /api && pip3 install -r ./requirements.txt

ENV EOSKEY ${EOSKEY}
CMD (if test -f "/volentix/node.key"; then echo "Node keys present"; exit 0; fi; echo "First start, generate key for node";openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -keyout /volentix/node.key -out /volentix/node.crt -subj /CN=example.com) && ((sleep 10;curl -v --retry 6 --retry-delay 10 -X SIGN -H "Content-Type: application/json" -d "{\"data\": \"$(echo {\"$(curl -s http://localhost:8100/ | python3 -c "import sys, json; print (json.load(sys.stdin)['node_id'])")\": \"$EOSKEY\"} | base64 -w 0)\"}" http://localhost:8100/eos) &) && (python3 /api/http_server.py > /api/log.txt &) && (dhtnode -s -b 95.216.0.79:4222 -n 1 -p 4222 -i --proxyserver 8100 --certificate /volentix/node.crt --privkey /volentix/node.key)
