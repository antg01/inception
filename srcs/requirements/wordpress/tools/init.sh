#!/bin/bash

# Préparer les répertoires
mkdir -p /var/www/html

cd /var/www/html
rm -rf *

# Télécharger et installer WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Télécharger WordPress
wp core download --allow-root

# Remplacer la config WordPress
mv /wp-config.php /var/www/html/wp-config.php

# Lire secrets
cred_file="/secrets/credentials.txt"
db_name_file="/secrets/db_name.txt"
db_user_file="/secrets/db_user.txt"
db_pwd_file="/secrets/db_password.txt"

if [ -f "$cred_file" ]
then
    source "$cred_file"
fi

if [ -f "$db_name_file" ]
then
    DB_NAME=$(cat "$db_name_file")
fi

if [ -f "$db_user_file" ]
then
    DB_USER=$(cat "$db_user_file")
fi

if [ -f "$db_pwd_file" ]
then
    DB_PWD=$(cat "$db_pwd_file")
fi

# Modifier wp-config.php dynamiquement
sed -i -r "s/db1/$DB_NAME/1" wp-config.php
sed -i -r "s/user/$DB_USER/1" wp-config.php
sed -i -r "s/pwd/$DB_PWD/1" wp-config.php

# Installer WordPress
wp core install --url=$DOMAIN_NAME/ --title=$WP_TITLE --admin_user=$WP_ADMIN_USR --admin_password=$WP_ADMIN_PWD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root

# Créer utilisateur secondaire
wp user create $WP_USR $WP_EMAIL --role=author --user_pass=$WP_PWD --allow-root

# Activer thème & plugin
wp theme install astra --activate --allow-root
wp plugin install redis-cache --activate --allow-root
wp plugin update --all --allow-root

# Config php-fpm
sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf
mkdir /run/php

wp redis enable --allow-root

# Lancer PHP-FPM
exec /usr/sbin/php-fpm7.3 -F

