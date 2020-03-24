FROM aberaud/opendht-deps

RUN apt-get update && apt-get install -y build-essential cmake git wget libncurses5-dev libreadline-dev nettle-dev libgnutls28-dev libuv1-dev cython3 python3-dev libcppunit-dev libjsoncpp-dev libasio-dev libssl-dev python3-setuptools openssl python3-pip curl && apt-get clean

#build msgpack from source
RUN wget https://github.com/msgpack/msgpack-c/releases/download/cpp-2.1.5/msgpack-2.1.5.tar.gz \
	&& tar -xzf msgpack-2.1.5.tar.gz \
	&& cd msgpack-2.1.5 && mkdir build && cd build \
	&& cmake -DMSGPACK_CXX11=ON -DMSGPACK_BUILD_EXAMPLES=OFF -DCMAKE_INSTALL_PREFIX=/usr .. \
	&& make -j8 && make install \
	&& cd ../.. && rm -rf msgpack-2.1.5 msgpack-2.1.5.tar.gz

# libasio-dev (1.10.6-3) is too old
RUN echo "** Building a recent version of asio ***" \
    && wget https://github.com/aberaud/asio/archive/a7d66ef4017d8f1b7f2cef1bb4ba8e23b0961571.tar.gz \
    && tar -xvf a7d66ef4017d8f1b7f2cef1bb4ba8e23b0961571.tar.gz && cd asio-a7d66ef4017d8f1b7f2cef1bb4ba8e23b0961571/asio \
    && ./autogen.sh && ./configure --prefix=/usr --without-boost --disable-examples --disable-tests  \
    && make install \
    && cd ../../ && rm -rf asio*

#build opendht
RUN git clone --recursive https://github.com/savoirfairelinux/opendht.git \
	&& cd opendht && sed -i 's/config.dht_config.node_config.maintain_storage = false/config.dht_config.node_config.maintain_storage = true/g' ./tools/dhtnode.cpp \
	&& sed -i 's/bool permanent = false/bool permanent = true/g' ./include/opendht/dht_proxy_client.h \
	&& sed -i 's/bool permanent = false/bool permanent = true/g' ./include/opendht/securedht.h \
	&& mkdir build && cd build \
	&& cmake -DCMAKE_INSTALL_PREFIX=/usr -DOPENDHT_PYTHON=On -DOPENDHT_LTO=On -DOPENDHT_C=ON -DOPENDHT_PROXY_SERVER=OFF -DOPENDHT_PROXY_CLIENT=OFF ..  \
	&& make -j8 && make install

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

# Bitcoin stuff
RUN curl https://bitcoin.org/bin/bitcoin-core-0.19.0.1/bitcoin-0.19.0.1-x86_64-linux-gnu.tar.gz > bitcoin.tar.gz
RUN tar xvf bitcoin.tar.gz
RUN cp /bitcoin-0.19.0.1/bin/bitcoin-cli /usr/bin
RUN cp -r /bitcoin-0.19.0.1/include/* /usr/include
RUN cp -r /bitcoin-0.19.0.1/lib/* /usr/lib
RUN cp -r /bitcoin-0.19.0.1/share/* /usr/share
RUN rm -rf /bitcoin*

#create dir for node keys
RUN mkdir /volentix

EXPOSE 8000/tcp
EXPOSE 8100/tcp
EXPOSE 4222/udp

COPY ./config/ /volentix/config/
COPY ./api /api
COPY ./mpt /mpt
RUN cd /api && cargo build --release
RUN cd /mpt && cargo build --release --bin sign && cargo build --release --bin generate_key
COPY /entrypoint.sh /entrypoint.sh
RUN chmod 700 /entrypoint.sh
RUN mv /api/target/release/api /usr/bin/api
RUN mv /mpt/target/release/sign /usr/bin/sign
RUN mv /mpt/target/release/generate_key /usr/bin/generate_key
RUN rm -rf /api /mpt /opendht /restbed /restinio

ENV EOSKEY ${EOSKEY}
WORKDIR /volentix
ENTRYPOINT ["/entrypoint.sh"]
