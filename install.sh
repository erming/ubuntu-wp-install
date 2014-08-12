#!/bin/bash
read -e -p "Target directory: " -i "/var/www" dir
dir=${dir:-"/var/www"}

read -e -p "Database: " -i "wordpress" db
db=${db:-"wordpress"}

if [ ! -d "$dir" ]; then
	sudo mkdir -p $dir
fi

sudo apt-get install -y \
	mysql-server \
	apache2 \
	libapache2-mod-php5 \
	php5-gd \
	php5-mysql \
	wget \
	unzip

sudo a2enmod rewrite
sudo replace "2M" "10M" -- /etc/php5/apache2/php.ini
sudo service apache2 restart

sudo mysql -e "CREATE DATABASE IF NOT EXISTS $db;"

cd $dir
sudo wget http://wordpress.org/latest.zip
sudo unzip latest.zip > /dev/null

sudo rm -rf wp-*/

sudo mv wordpress/* .
sudo rm -rf index.html wordpress latest.zip

sudo chown -R www-data:www-data $dir
sudo chmod -R 775 $dir

u=$SUDO_USER
if [ -z $u ]; then
	u=$USER
fi

if !(groups $u | grep >/dev/null www-data); then
	sudo adduser $u www-data
fi

cd - >/dev/null

echo ""
echo "Install complete!"
echo "Please restart your session."
echo ""
