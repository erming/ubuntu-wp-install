#!/bin/bash

pkgs=(
	"apache2"
	"libapache2-mod-php5"
	"mysql-server"
	"php5-gd"
	"php5-mysql"
)

for pkg in ${pkgs[@]}
do
	sudo apt-get install -y $pkg
done

sudo a2enmod rewrite
sudo service apache2 restart
