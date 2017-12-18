# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  # config.vbguest.auto_update = false

  # Spin up two controllers
  (1..2).each do |i|
    config.vm.define "controller-#{i}" do |controller|
      controller.vm.box = "ol74"
      controller.vm.hostname = "controller-#{i}"

      # Add host-only network interface
      controller.vm.network "private_network", ip: "192.168.56.2#{i}"

      # Add internal network interface
      controller.vm.network "private_network", ip: "10.10.10.1#{i}", virtualbox__intnet: "intnet"

      controller.vm.provider "virtualbox" do |vb|
           vb.name = "controller-#{i}"
           vb.memory = "8192"

           # Add third disk for cinder-volumes VG
           vg_disk_file = "cinder_volumes-con#{i}.vdi"
           unless File.exist?(vg_disk_file)
              vb.customize ['createhd', '--filename', vg_disk_file, '--size', 50 * 1024]
           end
           vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', vg_disk_file]


      end

      controller.vm.provision :shell, :path => "provision.sh"

      controller.vm.provision :shell, :path => "setup-vg.sh"

      if i == 1
         controller.vm.provision :shell, inline: <<-SHELL
            yum install -y openstack-kollacli openstack-kolla-utils
         SHELL
      end

    end
  end

  # Network node
  config.vm.define :network do |net|
    net.vm.box = "ol74"
    net.vm.hostname = "net"

    # Add host-only network interface
    net.vm.network "private_network", ip: "192.168.56.30"

    # Add second host-only network interface (only for this node)
    net.vm.network "private_network", ip: "192.168.99.10"

    # Add internal network interface
    net.vm.network "private_network", ip: "10.10.10.20", virtualbox__intnet: "intnet"

    net.vm.provider "virtualbox" do |vb|
      vb.name = "net"
      vb.memory = "2048"
    end

    net.vm.provision :shell, :path => "provision.sh"

  end

end
