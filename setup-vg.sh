#!/bin/sh

parted /dev/sdc mklabel msdos
parted /dev/sdc mkpart primary 1 100%
parted /dev/sdc set 1 lvm on

pvcreate /dev/sdc1

vgcreate cinder-volumes /dev/sdc1
