FROM aberaud/opendht-deps

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
