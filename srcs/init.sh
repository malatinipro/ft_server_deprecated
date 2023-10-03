#!/bin/bash

# Generate ssl keys
# mkdir /etc/nginx/ssl
# openssl req -x509 -newkey rsa:4096 -nodes -keyout /etc/nginx/ssl/localhost.key -out /etc/nginx/ssl/localhost.crt -days 365 -subj '/C=FR/ST=Paris/L=Paris/O=42Paris/CN=localhost'

# Start php-fpm service
service php7.3-fpm start

# Start nginx service
service nginx start

# Start mysql service and
service mysql start

# Creating database
mysql -u root -e "CREATE DATABASE $DB_NAME DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
mysql -u root -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER' IDENTIFIED BY '$DB_PASSWORD' WITH GRANT OPTION;"
mysql -u root -e "FLUSH PRIVILEGES;"
mysql -u root wordpress < wordpress.sql

# Installation de WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
php wp-cli.phar --info
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Connexion a la base de donnee pour Wordpress sans passer par le wp-config
wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --locale=ro_RO --allow-root --path="./localhost/wordpress"
#chown -R www-data:www-data ./localhost/wordpress

# Afficher les logs d'erreur s'il y en a
# tail -f var/log/nginx/error.log var/log/nginx/access.log

# Exporter la base de donnees / faire un "dump"
#php mp-cli.phar --export=dump.sql
