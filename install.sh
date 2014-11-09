#!/bin/bash
pwd=`dirname $0`

read -e -p "Target directory: " -i "/var/www" dir
dir=${dir:-"/var/www"}

read -e -p "Database: " -i "wordpress" db
db=${db:-"wordpress"}

if [ ! -d "$dir" ]; then
	sudo mkdir -p $dir
fi

sudo apt-get install -y \
	mysql-server \
	nginx \
	php5-fpm \
	php5-gd \
	php5-mysql \
	wget \
	unzip

sudo replace "2M" "10M" -- /etc/php5/fpm/php.ini
sudo service php5-fpm restart

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

sites="/etc/nginx/sites-enabled"

sudo cp "$pwd/conf/wordpress" $sites
sudo replace "/var/www" $dir -- "$sites/wordpress"

if [ -e "$sites/default" ]; then
	read -r -n 1 -p "Delete 'default' nginx site? (y/n)"
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		sudo rm "$sites/default"
	fi
	echo ""
fi

sudo service nginx restart

echo ""
echo "Install complete!"
echo "Please restart your session."
echo ""
