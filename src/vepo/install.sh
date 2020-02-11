#!/bin/bash

echo "Installing Vepo"

domain_name="$1"
auth64="$2"

if [ -z "$domain_name" ]
then
    echo "You must supply a domain_name."
    exit 1
fi

if [ -z "$auth64" ]
then
    echo "Authentication not valid"
    exit 1
fi


wget https://github.com/rancher/k3s/releases/download/v0.5.0/k3s

chmod +x k3s

sudo mv k3s /bin

sudo nohup  k3s server &>/dev/null &

echo "Sleeping while k3s starts up..."
sleep 15

curl -LO https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml

k3s kubectl apply -f local-path-storage.yaml

# sudo k3s kubectl delete -f /var/lib/rancher/k3s/server/manifests/traefik.yaml

sudo cp /var/lib/rancher/k3s/agent/kubeconfig.yaml ~/.kube/config

sudo chmod 777 ~/.kube/config

curl -sL https://run.linkerd.io/install | sh

export PATH=$PATH:$HOME/.linkerd2/bin

linkerd install | k3s kubectl apply -f -

echo "Sleeping while linkerd starts up..."

c=1
while [ $c -le 5 ]
do
    echo "Sleeping.... "
    sleep 20
    echo "Lets see if Linkerd is running"
    started=$(k3s kubectl get po --all-namespaces | grep linkerd)
    if [ ! -n "$started" ]
    then
        echo "Linkerd loading has not started... will now sleep because I am so tired...."
        continue
    fi
    remaining=$(k3s kubectl get po --all-namespaces | grep linkerd | grep -v Running)
    if [ ! -n "$remaining" ]
    then
        echo "Linkerd loaded!"
        break
    else
        echo "Linkerd NOT loaded"
        echo $remaining
        continue
    fi
done

sleep 10

# This is required to manage the password for the admin console.
sudo apt-get install apache2-utils -y

echo "***********************************************"
echo $domain_name
echo $auth64

sed 's/?domain_name?/'"$domain_name"'/' kube/0.linkerd.ingress.yaml.template | \
sed 's/?auth64?/'"$auth64"'/' | \
k3s kubectl apply -f -