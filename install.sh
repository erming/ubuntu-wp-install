#!/bin/bash
read -p "Target directory [/var/www]: " dir
dir=${dir:-"/var/www"}

read -p "Database [wordpress]: " db
db=${db:-"wordpress"}

if [ ! -d "$dir" ]; then
	sudo mkdir -p $dir
fi

sudo apt-get install -y mysql-server
sudo apt-get install -y apache2
sudo apt-get install -y libapache2-mod-php5
sudo apt-get install -y php5-gd
sudo apt-get install -y php5-mysql
sudo apt-get install -y wget
sudo apt-get install -y unzip

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
sudo adduser $USER www-data
sudo newgrp www-data

find $dir -type d | while read dir
	do sudo chmod 775 $dir
done

cd -

echo ""
echo "Script complete!"
echo ""
