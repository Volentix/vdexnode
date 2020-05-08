FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install curl -y

RUN curl https://bitcoin.org/bin/bitcoin-core-0.19.0.1/bitcoin-0.19.0.1-x86_64-linux-gnu.tar.gz > bitcoin.tar.gz
RUN tar xvf bitcoin.tar.gz
RUN cp -r /bitcoin-0.19.0.1/bin/* /usr/bin
RUN cp -r /bitcoin-0.19.0.1/include/* /usr/include
RUN cp -r /bitcoin-0.19.0.1/lib/* /usr/lib
RUN cp -r /bitcoin-0.19.0.1/share/* /usr/share
RUN rm -rf /bitcoin*

RUN mkdir -p /bitcoin \
	&& mkdir -p /bitcoin/data

ADD docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

VOLUME ["/bitcoin/data"]

EXPOSE 8332 8333 18332 18333 18443 18444

ENTRYPOINT ["/docker-entrypoint.sh"]