# Install opendht on Ubuntu 16.04:
1. Install debs:
'''bash
apt-get update && apt-get install -y build-essential cmake git wget libncurses5-dev libreadline-dev nettle-dev libgnutls28-dev libuv1-dev cython3 python3-dev libcppunit-dev libjsoncpp-dev libasio-dev libssl-dev python3-setuptools
'''

2. Install restbed and msgpack from git:
'''bash
cd /opt
git clone --recursive https://github.com/corvusoft/restbed.git && cd restbed && mkdir build && cd build && cmake -DBUILD_TESTS=NO -DBUILD_EXAMPLES=NO -DBUILD_SSL=NO -DBUILD_SHARED=YES -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib .. && make -j8 install && cd .. && rm -rf restbed
cd /opt
wget https://github.com/msgpack/msgpack-c/releases/download/cpp-2.1.5/msgpack-2.1.5.tar.gz && tar -xzf msgpack-2.1.5.tar.gz && cd msgpack-2.1.5 && mkdir build && cd build && cmake -DMSGPACK_CXX11=ON -DMSGPACK_BUILD_EXAMPLES=OFF -DCMAKE_INSTALL_PREFIX=/usr .. && make -j8 && make install && cd ../.. && rm -rf msgpack-2.1.5 msgpack-2.1.5.tar.gz
'''

3. Install node with proxy support:
'''bash
cd /opt/
git clone --recursive https://github.com/savoirfairelinux/opendht.git
cd /opt/opendht 
mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/usr -DOPENDHT_PYTHON=On -DOPENDHT_LTO=On -DOPENDHT_TESTS=ON -DOPENDHT_PROXY_SERVER=ON .. && make -j8 && ./opendht_unit_tests && make install
'''

4. Create static keys for node:
'''bash
mkdir /root/opendht && cd /root/opendht
dhtnode -b IP_your_SERVER:4222 -p 4222 -i --proxyserver 8100 --save-identity ./node
Type exit.
'''
 
5. Make system service:
nano /etc/systemd/system/opendht-node.service
And copy text:
'''bash
[Unit]
Description=opendht node
After=network.target

[Service]
Type=simple
Restart=always
WorkingDirectory=/root/opendht
ExecStart=/usr/bin/dhtnode -s -b bootstap_node_ip:4222 -p 4222 -i --proxyserver 8100 --certificate /root/opendht/node.crt --privkey /root/opendht/node.pem
RestartSec=10
TimeoutStopSec=20
TimeoutStartSec=5
StartLimitBurst=5
StartLimitInterval=120
KillMode=mixed
SyslogIdentifier=opendhtnode
PrivateTmp=true

[Install]
WantedBy=multi-user.target
'''
Save file
Enable and run opendtt node
'''bash
systemctl daemon-reload
systemctl enable opendht-node
systemctl start opendht-node
'''
