# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
	#config.vm.box_url
	#
    config.vm.define "mybox" do |mybox|
	mybox.vm.box = "test"
        mybox.vm.box = "puphpet/centos65-x64"
	mybox.vm.network "private_network", ip: "192.168.33.10" 
	mybox.vm.provider "virtualbox" do |vb|
        vb.memory = "512"
	mybox.vm.network "forwarded_port", guest: 80, host: 8888
    config.vm.provision "shell", inline: <<-SHELL
        groupadd -g 27 mysql
		useradd -u 27 -c "MySQL svc user" -g 27 mysql
        yum -y --disablerepo="epel" install httpd
	    yum -y --disablerepo="epel" install mysql-server mysql
		yum -y --disablerepo="epel" install php php-mysql php-gd php-xml
		service httpd start
		service mysqld start
		#mysql_secure_installation
		chkconfig httpd on
		chkconfig mysqld on
		echo "<?php phpinfo(); ?>" >>/var/www/html/info.php
		service httpd restart
		iptables -I INPUT 4 -p tcp --dport 80 -j ACCEPT
		/vagrant/wiki_install.sh
    SHELL
	end
    end

end

   # yum --disablerepo="epel" install salt-master
   #   sudo apt-get update
   #   sudo apt-get install -y apache2
   #    service apache2 start
   #config.vm.box_check_update = false
   #config.vm.network "forwarded_port", guest: 80, host: 8080
   #config.vm.network "public_network"
   #config.vm.synced_folder "../data", "/vagrant_data"
