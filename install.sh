#!/bin/bash
dir="/var/www"
if [ -n "$1" ]; then
	dir="$1"
fi
if [ ! -d "$dir" ]; then
	sudo mkdir -p $dir
fi

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
sudo replace "2M" "10M" -- /etc/php5/apache2/php.ini
sudo service apache2 restart

sudo mysql -e "CREATE DATABASE IF NOT EXISTS wordpress;"

cd $dir
sudo wget http://wordpress.org/latest.zip
sudo unzip latest.zip

sudo mv wordpress/* .
sudo rm -rf index.html wordpress latest.zip

sudo chown -R www-data:www-data $dir
sudo adduser $USER www-data

find $dir -type d | while read dir
	do sudo chmod 775 $dir
done

echo
echo "Script complete!"
echo "Please relog current user before proceeding."
