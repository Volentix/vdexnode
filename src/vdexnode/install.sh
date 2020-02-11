#!/bin/bash

# install_vdex - A simple command to install an instance of vdex on k8s.

vtx_public_address="$1"
namespace="$2"
domain_name="$3"

if [ -z "$vtx_public_address" ]
then
    echo "You must supply an address, namespace, and domain_name."
    exit 1
fi

if [ -z "$namespace" ]
then
    echo "You must supply a namespace and domain_name."
    exit 1
fi

if [ -z "$domain_name" ]
then
    echo "You must supply a domain_name."
    exit 1
fi



existingns=$(k3s kubectl get namespaces | grep "$namespace")

if [ -z "$existingns" ]
then
    # Make sure that Linkerd is set up.
    sleep 10
    vtx_address_base64=$(echo -n "$vtx_public_address" | base64)
    export PATH=$PATH:$HOME/.linkerd2/bin
    
    sed 's/?vdex_namespace?/'"$namespace"'/' kube/0.vdex.yaml.template | \
    sed 's/?vtx_address?/'"$vtx_address_base64"'/' | \
    sed 's/?domain_name?/'"$domain_name"'/' | \
    linkerd inject - | \
    k3s kubectl apply -f -
else
    echo "The namespace $namespace already exists"
    echo "Please delete the namespace or choose another namespace"
fi




