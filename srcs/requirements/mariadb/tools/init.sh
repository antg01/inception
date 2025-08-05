#!/bin/sh
set -ex

# Lire les secrets
DB_NAME=$(cat /secrets/db_name.txt)
DB_USER=$(cat /secrets/db_user.txt)
USER_PWD=$(cat /secrets/db_password.txt)
ROOT_PWD=$(cat /secrets/db_root_password.txt)

# Initialiser la DB si vide
if [ ! -d "/var/lib/mysql/mysql" ]
then
    echo "Initialisation de la base MariaDB..."
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

# Démarrer MariaDB (en avant-plan, PID 1)
exec mysqld_safe --datadir=/var/lib/mysql \
    --skip-networking=0 \
    --bind-address=0.0.0.0 \
    --skip-name-resolve \
    --log-error=/var/log/mysql/error.log \
    --pid-file=/run/mysqld/mysqld.pid \
    --socket=/run/mysqld/mysqld.sock &

# Attendre que MariaDB réponde
until mysqladmin ping --silent --password="$ROOT_PWD" --user=root
do
    echo "⏳ Attente de MariaDB..."
    sleep 2
done

# Configurer la base
mysql -u root -p"$ROOT_PWD" <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PWD';
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$USER_PWD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF

# Garder le conteneur actif
wait
