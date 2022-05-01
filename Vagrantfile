# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.define "ad-dc", autostart: false do |box|
    box.vm.box = "debian/contrib-buster64"

    box.vm.network "private_network", ip: "192.168.50.10", virtualbox__intnet: true

    box.vm.synced_folder ".", "/srv/salt"

    box.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      #vb.gui = true
    
      vb.linked_clone = true

      # Customize the amount of memory on the VM:
      vb.memory = "1024"
    end

    box.vm.provision 'salt' do |salt|
      salt.masterless = true
      salt.run_highstate = true
      salt.verbose = true
    end
  end

  config.vm.define "ad-member", autostart: false do |box|
    box.vm.box = "gusztavvargadr/windows-server-2016-standard"
    box.vm.network "private_network", ip: "192.168.50.20", virtualbox__intnet: true
    box.vm.provider "virtualbox" do |vb|
      #vb.gui = true
      vb.linked_clone = true
      #vb.memory = "1024"
    end
    box.vm.provision "shell", inline: <<-SHELL
      Get-NetIPAddress -IPAddress 192.168.50.20 | Set-DnsClientServerAddress -ServerAddress 192.168.50.10
SHELL
  end
end
