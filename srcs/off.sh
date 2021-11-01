sed -i 's/autoindex on/autoindex off/g' default
sed -i 's/autoindex on/autoindex off/g' nginx.conf
sed -i 's/index index.html index.htm index.php/index index.html index.htm/g' /etc/nginx/sites-enabled/default
service nginx restart