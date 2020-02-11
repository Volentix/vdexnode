#!/bin/bash

# Script for running the repo stuff without even cloning the repo.
echo "Running the main install script."

username='sylvain'
password='test'
credentials="$(echo -n "$username:$password" | base64)"
header="Authorization: Basic $credentials"

vtx_public_address="$1"
namespace="$2"
domain_name="$3"
#auth64="$4"
auth64=$header

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

if [ -z "$auth64" ]
then
    echo "You must supply a the base 64 apache auth information."
    exit 1
fi

cd src/vepo

sh ./install.sh $domain_name $auth64

echo "Installing vDexNode."

cd ../vdexnode

sh ./install.sh $vtx_public_address $namespace $domain_name

echo "Install fully complete"