

# This will be our base container image
FROM ubuntu


RUN apt-get update

RUN apt install -y pagekite autoconf libtool git pkg-config cmake-data cmake libncurses5-dev libreadline-dev nettle-dev libgnutls28-dev libargon2-0-dev libmsgpack-dev librestbed-dev libjsoncpp-dev cython3 python3-dev python3-setuptools build-essential argon2 libargon2-0 libargon2-0-dev
COPY . .


RUN mkdir build 
RUN cd build

RUN ./autogen.sh && ./configure --prefix=/usr

RUN make -j4
RUN make install

# EXPOSE  20000 2001 20002


# USER $USER:$USER


