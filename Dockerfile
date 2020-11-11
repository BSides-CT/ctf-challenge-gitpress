# Get base image
FROM debian:buster

# Install required packages
RUN apt-get update && apt-get install -y sudo curl nmap mariadb-server php php-mysql libapache2-mod-php apache2

# Configure listening ports
RUN sed -i 's/bind-address *= 127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
RUN rm /var/www/html/index.html

# Install custom files
COPY ./files/start.sh /
COPY ./files/mysql /var/lib/mysql
COPY ./files/html /var/www/html
COPY ./files/flag3.txt /var/www/flag3.txt
COPY ./files/flag4.txt /root/flag4.txt

# Set file permissions
RUN chmod 755 /start.sh
RUN chown -R www-data:www-data /var/www
RUN chmod -R 755 /var/www
RUN chown -R root:mysql /var/lib/mysql
RUN chmod -R 770 /var/lib/mysql
RUN chown root:root /root/flag4.txt
RUN chmod 600 /root/flag4.txt
RUN echo "ALL ALL=(ALL:ALL) NOPASSWD:/usr/bin/nmap" >/etc/sudoers.d/nmap
RUN sudo --list -U www-data

# Start services
CMD ["/start.sh"]
