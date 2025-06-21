FROM amazonlinux:2023

LABEL "name"="wiki" \
      "version"="1.0" \
      "description"="A Docker image for a wiki application with Apache and MySQL"

MAINTAINER "nayrslohcin"

RUN apt-get -y update 
apt-get install -y apache2 
apt-get install -y mysql-server libapache2-mod-auth-mysql php5-mysql
apt-get install -y php5 libapache2-mod-php5 php5-mcrypt

EXPOSE 80 3306
VOLUME /var/www/html
WORKDIR /var/www/html
COPY html/ /var/www/html
RUN chown -R apache:apache /var/www/html && \
    chmod -R 755 /var/www/html
CMD mysql_install_db && /usr/bin/mysql_secure_installation

ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]

