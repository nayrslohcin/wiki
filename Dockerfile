 FROM ubuntu

RUN apt-get -y update && apt-get install -y apache2 && apt-get install -y mysql-server libapache2-mod-auth-mysql php5-mysql && apt-get install -y php5 libapache2-mod-php5 php5-mcrypt

CMD mysql_install_db && /usr/bin/mysql_secure_installation
