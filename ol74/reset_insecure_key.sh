#!/bin/sh

rm /home/vagrant/.ssh/authorized_keys
wget --no-check-certificate \
     https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub \
     -O /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
