FROM aberaud/opendht-deps

RUN apt-get update && apt-get install -y build-essential cmake git wget libncurses5-dev libreadline-dev nettle-dev libgnutls28-dev libuv1-dev cython3 python3-dev libcppunit-dev libjsoncpp-dev libasio-dev libssl-dev python3-setuptools openssl python3-pip curl && apt-get clean

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
	&& cmake -DCMAKE_INSTALL_PREFIX=/usr -DOPENDHT_PYTHON=On -DOPENDHT_LTO=On -DOPENDHT_C=ON ..  \
	&& make -j && make install

# Install Rust (nightly needed for Rocket)
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN set -eux; \
    \
    url="https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init"; \
    wget "$url"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain nightly; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME;

#create dir for node keys
RUN mkdir /volentix

EXPOSE 8000/tcp
EXPOSE 8100/tcp
EXPOSE 4222/udp

COPY ./api /api
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod 700 entrypoint.sh
RUN cd /api && cargo build --release
RUN mv /api/target/release/api /usr/bin/api
RUN rm -rf /api/target /api/Cargo.lock

ENV EOSKEY ${EOSKEY}
CMD /entrypoint.sh
