#!/bin/sh
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -yq update
DEBIAN_FRONTEND=noninteractive apt-get -yq install apache2
systemctl start apache2.service
echo "<html><h3>Hello SODO!</h3></html>" > /var/www/html/index.html