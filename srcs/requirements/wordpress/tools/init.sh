#!/bin/bash

set -ex

TMP_WP=/tmp/wordpress
mkdir -p $TMP_WP
cd $TMP_WP
rm -rf *

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

wp core download --allow-root

cred_file="/secrets/wp_credentials.txt"
db_name_file="/secrets/db_name.txt"
db_user_file="/secrets/db_user.txt"
db_pwd_file="/secrets/db_password.txt"

if [ -f "$cred_file" ]; then source "$cred_file"; fi
if [ -f "$db_name_file" ]; then DB_NAME=$(cat "$db_name_file"); fi
if [ -f "$db_user_file" ]; then DB_USER=$(cat "$db_user_file"); fi
if [ -f "$db_pwd_file" ]; then DB_PWD=$(cat "$db_pwd_file"); fi

until nc -z mariadb 3306; do
    echo "Waiting for MariaDB to be ready..."
    sleep 2
done

if [ ! -f /var/www/html/index.php ]
then
    cp -r $TMP_WP/* /var/www/html
    cp /wp-config.php /var/www/html/wp-config.php
    sed -i -r "s/db1/$DB_NAME/1" /var/www/html/wp-config.php
    sed -i -r "s/user/$DB_USER/1" /var/www/html/wp-config.php
    sed -i -r "s/pwd/$DB_PWD/1" /var/www/html/wp-config.php
fi

if ! wp --path=/var/www/html core is-installed --allow-root
then
    wp --path=/var/www/html core install \
        --url=$DOMAIN_NAME/ \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USR \
        --admin_password=$WP_ADMIN_PWD \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email --allow-root
fi

if ! wp --path=/var/www/html user list --allow-root | grep -q "$WP_USR"
then
    wp --path=/var/www/html user create $WP_USR $WP_EMAIL \
        --role=author --user_pass=$WP_PWD --allow-root
fi

wp --path=/var/www/html theme install astra --activate --allow-root
wp --path=/var/www/html plugin install redis-cache --activate --allow-root
wp --path=/var/www/html plugin update --all --allow-root

mkdir -p /run/php
# Assurer que PHP-FPM écoute en TCP sur 0.0.0.0:9000
sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/7.3/fpm/pool.d/www.conf

# S'assurer que les permissions sont compatibles avec TCP
sed -i 's|^;listen.owner = .*|listen.owner = www-data|' /etc/php/7.3/fpm/pool.d/www.conf
sed -i 's|^;listen.group = .*|listen.group = www-data|' /etc/php/7.3/fpm/pool.d/www.conf
sed -i 's|^;listen.mode = .*|listen.mode = 0660|' /etc/php/7.3/fpm/pool.d/www.conf

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

exec /usr/sbin/php-fpm7.3 -F
