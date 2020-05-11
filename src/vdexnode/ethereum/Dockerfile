FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install -y wget \
    && rm -rf /var/lib/apt/lists/* \
    && wget https://releases.parity.io/ethereum/v2.7.2/x86_64-unknown-linux-gnu/parity \
    && chmod 755 parity

RUN mkdir -p /ethereum \
    && mkdir /ethereum/data \
    && mkdir /ethereum/data/chains \
    && mkdir /ethereum/data/keys

COPY .  /ethereum

WORKDIR "/ethereum"

RUN mv /parity /ethereum/ \
    && mv docker-entrypoint.sh /usr/local/bin/ \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 30304 8546 8547

ENTRYPOINT ["docker-entrypoint.sh"]
