#!/bin/bash
EXTERNALIP=$(curl 'https://api.ipify.org')
sed -i 's/changeme/'"$EXTERNALIP"'/' /var/www/html/wp-config.php
service mysql start
apache2ctl -D FOREGROUND
