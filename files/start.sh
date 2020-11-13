#!/bin/bash

# Configure WP site URL with external IP
# Comment out these two lines to test on localhost
EXTERNALIP=$(curl -s 'https://api.ipify.org')
sed -i 's|http://localhost|http://'"$EXTERNALIP"'|' /var/www/html/wp-config.php

# Start services
service mysql start
apache2ctl -D FOREGROUND
