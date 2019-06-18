FROM ubuntu:16.04

RUN apt-get update && apt-get install -y build-essential cmake git wget libncurses5-dev libreadline-dev nettle-dev libgnutls28-dev libuv1-dev  cython3 python3-dev libcppunit-dev libjsoncpp-dev libasio-dev libssl-dev python3-setuptools openssl && apt-get clean

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
	&& cd opendht && mkdir build && cd build \
	&& cmake -DCMAKE_INSTALL_PREFIX=/usr -DOPENDHT_PYTHON=On -DOPENDHT_LTO=On -DOPENDHT_TESTS=ON -DOPENDHT_PROXY_SERVER=ON ..  \
	&& make -j8 && ./opendht_unit_tests && make install

#create node keys
RUN mkdir /volentix && cd /volentix && openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -keyout ./node.key -out ./node.crt -subj /CN=example.com

EXPOSE 8100/tcp
EXPOSE 4222/udp

CMD dhtnode -s -b 95.216.0.79:4222 -p 4222 -i --proxyserver 8100 --certificate /volentix/node.crt --privkey /volentix/node.key
