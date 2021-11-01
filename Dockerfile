# Install OS in your virtual environment
FROM debian:buster 

# Name the maintainer
LABEL maintainer=malatini

ENV DB_NAME 'wordpress'
ENV DB_USER 'malatini'
ENV DB_PASSWORD 'pass'

# Update sofware packages in debian, the -y option answers yes to all questions
RUN apt-get update && apt-get upgrade -y

#Installing PHP and some extensions/librairies
RUN apt-get -y install php7.3 \
					php-mysql \
					php-fpm \
					php-mysqli

# Installing Nginx Web Serveur
RUN apt-get install -y nginx \
# Wget will be used to get .tar file of phpmyadmin and wordpress
		wget \
# SSL tool
		openssl \
# MariaDB/MySQL Easier to use on Debian and perfect with Wordpress
		mariadb-server \
# Besoin de curl pour installer WP-CLI
		curl 
RUN mkdir -p /usr/share/localhost/wordpress
# Installing PhpMyAdmin (PMA)
WORKDIR /usr/share/localhost
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar -xf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english phpmyadmin
COPY /srcs/config.inc.php /usr/share/localhost/phpmyadmin
RUN chown -R www-data:www-data .


#Installation de Wordpress et edition du fichier de configuration
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz && rm -rf latest.tar.gz

WORKDIR /etc/nginx
# Copy pasting our configuration files for phpmyadmin and wordpress into the container
COPY srcs/sites-available/* /etc/nginx/sites-available/

# Creating symbolic link for sites-enables
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled
COPY srcs/off.sh /etc/nginx/sites-available/
COPY srcs/on.sh /etc/nginx/sites-available/

#RUN rm -rf /var/www/html/*
WORKDIR /usr/share/
COPY srcs/wordpress.sql /usr/share
COPY srcs/init.sh /usr/share
CMD echo "WELCOME ON BOARD\n" && bash init.sh && bash

# Useful commands 

# Build image 
# 	docker build -t ft_server .

# Run the container 
#	the it option allows you to specify that the current terminal will become the console
# 	docker run --rm --name ftservercontainer -it -p 80:80 -p 443:443 ft_server
