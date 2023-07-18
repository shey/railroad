# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/focal64"

  config.ssh.insert_key = true
  config.ssh.forward_agent = true

  ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
  config.vm.provision "shell", inline: <<-SHELL
    echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
  SHELL

  # General VirtualBox VM configuration.
  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--cpus", 4]
    v.customize ["modifyvm", :id, "--memory", 2048]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    v.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define "app" do |app|
    app.vm.hostname = "vagrant-app"
    app.vm.network :private_network, ip: "192.168.56.41"
  end

end
