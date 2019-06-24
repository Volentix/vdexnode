#!/bin/bash

# install_vdex - A simple command to install an instance of vdex on k8s.

vtx_public_address="$1"
namespace="$2"

if [ -z "$vtx_public_address" ]
then
    echo "You must supply an address and namespace"
    exit 1
fi

if [ -z "$namespace" ]
then
    echo "You must supply a namespace"
    exit 1
fi

existingns=$(k3s kubectl get namespaces | grep "$namespace")
if [ -z "$existingns" ]
then
    vtx_address_base64=$(echo -n "$vtx_public_address" | base64)
    mkdir deploy
    sed 's/vdex_namespace/'"$namespace"'/' 0.namespace.yaml.template > deploy/0.namespace.yaml
    sed 's/vdex_namespace/'"$namespace"'/' 1.address-secret.yaml.template | sed 's/vtx_address/'"$vtx_address_base64"'/' > deploy/1.address_secret.yaml
    sed 's/vdex_namespace/'"$namespace"'/' 2.vdex.yaml.template > deploy/2.vdex.yaml

    k3s kubectl apply -f deploy/0.namespace.yaml
    k3s kubectl apply -f deploy/1.address_secret.yaml
    k3s kubectl apply -f deploy/2.vdex.yaml
else
    echo "The namespace $namespace already exists"
    echo "Pleaase delete the namespace or choose another namespace"
fi




