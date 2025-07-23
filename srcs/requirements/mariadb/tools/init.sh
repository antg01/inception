#!/bin/bash

# Démarrer le service MariaDB
service mysql start

# Lire les variables depuis les fichiers secrets
root_pwd_file="/secrets/db_root_password.txt"
user_pwd_file="/secrets/db_password.txt"

db_name_file="/secrets/db_name.txt"
db_user_file="/secrets/db_user.txt"

if [ -f "$root_pwd_file" ]
then
    ROOT_PWD=$(cat "$root_pwd_file")
fi

if [ -f "$user_pwd_file" ]
then
    USER_PWD=$(cat "$user_pwd_file")
fi

if [ -f "$db_name_file" ]
then
    DB_NAME=$(cat "$db_name_file")
fi

if [ -f "$db_user_file" ]
then
    DB_USER=$(cat "$db_user_file")
fi

# Créer les commandes SQL dynamiquement
echo "CREATE DATABASE IF NOT EXISTS $DB_NAME;" > db.sql
echo "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$USER_PWD';" >> db.sql
echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';" >> db.sql
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PWD';" >> db.sql
echo "FLUSH PRIVILEGES;" >> db.sql

# Exécuter les commandes SQL
mysql < db.sql

# Nettoyer le processus initial et lancer mariadb
kill $(cat /var/run/mysqld/mysqld.pid)

exec mysqld

