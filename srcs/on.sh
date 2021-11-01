sed -i 's/autoindex off/autoindex on/g' default
sed -i 's/autoindex off/autoindex on/g' nginx.conf
sed -i 's/index index.html index.htm index.php/index index.html index.htm/g' /etc/nginx/sites-enabled/default
service nginx restart
