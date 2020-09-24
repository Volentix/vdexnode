#!/bin/bash

echo "Running the main install script."


eoskey="EOS6PdTCWZgWMh4s5EDxYK3aL6DPC2ksDusTQpxE38QVmUzYLjLt9"
bootstrap="198.50.136.143"
bitcoin_user="sylvain"
bitcoin_pass="VBtu_InZ1oTL1oeKkZbSm97QzLMTPr0yvo6AFY0GFT4="
bitcoin_endpoint="bitcoin"
bitcoin_port="18443"


echo "Installing Vepo"

wget https://github.com/rancher/k3s/releases/download/v1.17.3%2Bk3s1/k3s 

chmod +x k3s

sudo mv k3s /bin

#sudo nohup  k3s server --kube-apiserver-arg service-node-port-range=4000-10000  &>/dev/null &
sudo nohup  k3s server  --kubelet-arg eviction-hard= eviction-minimum-reclaim=  --docker --kube-apiserver-arg service-node-port-range=4000-10000  &>/dev/null &

echo "Sleeping while k3s starts up..."
sleep 15

curl -LO https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml

k3s kubectl apply -f local-path-storage.yaml

sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config

sudo chmod 777 ~/.kube/config

echo "Installing vDexNode."

wget https://raw.githubusercontent.com/Volentix/vDexNode/master/Kubernetes/0.vdex.yaml.template


 sed -i  's/eoskey/'"$eoskey"'/' 0.vdex.yaml.template
 sed -i  's/bootstrap/'"$bootstrap"'/' 0.vdex.yaml.template
 sed -i  's/bitcoin_user/'"$bitcoin_user"'/' 0.vdex.yaml.template
 sed -i  's/bitcoin_pass/'"$bitcoin_pass"'/' 0.vdex.yaml.template
 sed -i  's/bitcoin_endpoint/'"$bitcoin_endpoint"'/' 0.vdex.yaml.template
 sed -i  's/bitcoin_port/'"$bitcoin_port"'/' 0.vdex.yaml.template
 
k3s kubectl apply -f 0.vdex.yaml.template


echo "Install fully complete"

