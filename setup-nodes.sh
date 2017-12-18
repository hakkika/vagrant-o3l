#!/bin/sh

if [ "$USER" != "kolla" ]; then
    echo "This script must be run as user kolla"
    exit 1
fi

# This is script is run manually on the controller-1 node

kollacli host add controller-1
kollacli host add controller-2
kollacli host add network
kollacli host add comp-1
kollacli host add comp-2

kollacli host list

kollacli host setup --file /vagrant/node-passwords.yml

kollacli host check all

kollacli group addhost control controller-1
kollacli group addhost control controller-2
kollacli group addhost database controller-1
kollacli group addhost database controller-2
kollacli group addhost storage controller-1
kollacli group addhost storage controller-2

kollacli group addhost network network

kollacli group addhost compute comp-1
kollacli group addhost compute comp-2

kollacli group listhosts
kollacli host list
