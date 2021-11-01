#!/bin/bash

mkdir /etc/nginx/ssl
openssl req -x509 -newkey rsa:4096 -nodes -keyout /etc/nginx/ssl/localhost.key -out /etc/nginx/ssl/localhost.crt -days 365 -subj '/C=FR/ST=Paris/L=Paris/O=42Paris/CN=localhost'
service php7.3-fpm start
service mysql start
mysql -u root -e "CREATE DATABASE $DB_NAME DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
mysql -u root -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER' IDENTIFIED BY '$DB_PASSWORD' WITH GRANT OPTION;"
mysql -u root -e "FLUSH PRIVILEGES;"
mysql -u root wordpress < wordpress.sql
# Installations et configurations supplementaires suite aux notes Discord
# Installation de WP-CLI - voir documentation officielle
# Une section "commande" liste toutes les commandes disponibles
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# Verifier que tout fonctionne 
php wp-cli.phar --info
# Pour utiliser WP-CLI à partir de la ligne de commande en tapant wp, rendez le fichier exécutable et déplacez-le quelque part dans votre PATH. 
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
# Connexion a la base de donnee pour Wordpress sans passer par le wp-config
wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --locale=ro_RO --allow-root --path="./localhost/wordpress"
# La partie "wp-db" permet d'interagir avec la base de donnees
#wp core install --allow-root --path="./localhost/wordpress" --url=localhost --title="Mon super wordpress" --admin_name=$DB_UDSER --admin_password=$DB_USER  --admin_email=malatini@student.42.fr
chown -R www-data:www-data ./localhost/wordpress
#cp /usr/share/localhost/wordpress /usr/share/nginx/sites-available/
service nginx start
# Afficher les logs d'erreur s'il y en a
# tail -f var/log/nginx/error.log var/log/nginx/access.log

# Exporter la base de donnees / faire un "dump"
#php mp-cli.phar --export=dump.sql