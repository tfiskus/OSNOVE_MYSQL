sudo cp /etc/apache2/sites-available/algebra_test.conf /etc/apache2/sites-available/osnove_mysql.conf
sudo a2dissite osnove_php.conf 
sudo a2ensite osnove_mysql.conf 
ll /etc/apache2/sites-enabled/
sudo service apache2 restart

sudo nano /etc/apache2/sites-available/osnove_mysql.conf

# U osnove_mysql.conf dodati konfiguraciju ispod
# <VirtualHost *:80>
#     ServerAdmin algebra@localhost
#     DocumentRoot /var/www

#     ErrorLog ${APACHE_LOG_DIR}/error.log
#     CustomLog ${APACHE_LOG_DIR}/access.log combined

#     <Directory /var/www>
#         Options Indexes FollowSymLinks
#         AllowOverride All
#         Require all granted
#     </Directory>

#     Alias /phpmyadmin /usr/share/phpmyadmin
#     <Directory /usr/share/phpmyadmin>
#         Options FollowSymLinks
#         DirectoryIndex index.php
#         Require all granted
#     </Directory>
# </VirtualHost>

sudo service apache2 restart

sudo apt install -y phpmyadmin
sudo phpenmod -v ALL mbstring
sudo systemctl restart apache2