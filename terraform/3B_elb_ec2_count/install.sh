#!/bin/sh
systemctl start apache2.service
systemctl enable apache2.service
echo "<html><h3>Hello SODO!</h3>" > /var/www/html/index.html
echo "</br><p>Instance: " >> /var/www/html/index.html
curl http://169.254.169.254/latest/meta-data/local-hostname >> /var/www/html/index.html
echo "</p></html>" >> /var/www/html/index.html
