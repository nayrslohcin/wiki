#!/bin/bash

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


< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-8} > /root/mysql_root.pass;



PASS=`cat /root/mysql_root.pass`

echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$PASS')" > /root/set.pass

cat << EOF >> /root/create.wiki
CREATE USER 'wiki'@'localhost' IDENTIFIED BY 'password';
CREATE DATABASE wikidb;
GRANT ALL PRIVILEGES ON wikidb.* TO 'wiki'@'localhost';
DROP USER ''@'localhost';
DROP USER ''@'$(hostname)';
DROP DATABASE test;
FLUSH PRIVILEGES;
EOF

mysql -u root < /root/create.wiki
#mysql -u root < /root/set.pass
#rm /root/create.wiki
#rm /root/set.pass

cd /root
wget http://releases.wikimedia.org/mediawiki/1.25/mediawiki-1.25.3.tar.gz
#curl -O http://releases.wikimedia.org/mediawiki/1.25/mediawiki-1.25.3.tar.gz
#curl -O http://releases.wikimedia.org/mediawiki/1.25/mediawiki-1.25.3.tar.gz.sig
#gpg --verify mediawiki-1.25.3.tar.gz.sig mediawiki-1.25.3.tar.gz

VAL=$?

if [ $VAL != 0 ]
then
	exit 1
else
	cd /var/www/html
	tar -zxf /root/mediawiki-1.25.3.tar.gz
	ln -s /var/www/html/mediawiki-1.25.3 /var/www/html/mediawiki
	chown -R apache:apache /var/www/html/mediawiki-1.25.3
	cp ./LocalSettings.php /var/www/html/mediawiki
fi

sed -i 's/DirectoryIndex.*$/DirectoryIndex index.html index.html.var index.php/' /etc/httpd/conf/httpd.conf
