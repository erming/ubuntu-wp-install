#!/bin/bash

pkgs="
	mysql-server
	apache2
	libapache2-mod-php5
	php5-gd
	php5-mysql
	wget
	unzip
"

sudo apt-get install -y $pkgs

sudo a2enmod rewrite
sudo service apache2 restart

sudo mysql -e "CREATE DATABASE IF NOT EXISTS wordpress;"

cd /var/www
sudo wget http://wordpress.org/latest.zip
sudo unzip latest.zip
sudo mv wordpress/* .
sudo rm -rf index.html wordpress latest.zip

sudo chown -R www-data:www-data /var/www
sudo adduser $USER www-data

find /var/www -type d | while read dir; do sudo chmod 775 $dir; done

echo
echo "Script complete!"
echo "Please relog current user before proceeding."
