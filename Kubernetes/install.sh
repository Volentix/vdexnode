#!/bin/bash

echo "Running the main install script."

vtx_public_address="127.0.0.1"
namespace="vdex"
domain_name="test.com"
auth64="test1234"
vtx_address_base64=$(echo -n "$vtx_public_address" | base64)

echo "Installing Vepo"

wget https://github.com/rancher/k3s/releases/download/v1.17.3%2Bk3s1/k3s 

chmod +x k3s

sudo mv k3s /bin

sudo nohup  k3s server --kube-apiserver-arg service-node-port-range=4000-10000  &>/dev/null &

echo "Sleeping while k3s starts up..."
sleep 15

curl -LO https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml

k3s kubectl apply -f local-path-storage.yaml

sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config

sudo chmod 777 ~/.kube/config

echo "Installing vDexNode."

# wget https://raw.githubusercontent.com/Volentix/vDexNetwork/master/src/vdexnode/kube/0.vdex.yaml.template => for final version for the moment we use local file


 sed -i  's/?vdex_namespace?/'"$namespace"'/' 0.vdex.yaml.template
 sed -i  's/?vtx_address?/'"$vtx_address_base64"'/' 0.vdex.yaml.template
 sed -i  's/?domain_name?/'"$domain_name"'/' 0.vdex.yaml.template
 k3s kubectl apply -f 0.vdex.yaml.template

echo "Install fully complete"

