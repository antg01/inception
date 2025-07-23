#!/bin/bash

set -e

# Lire les variables
ROOT_PWD=$(cat /secrets/db_root_password.txt)
USER_PWD=$(cat /secrets/db_password.txt)
DB_NAME=$(cat /secrets/db_name.txt)
DB_USER=$(cat /secrets/db_user.txt)

# Démarrer MariaDB temporairement
mysqld_safe --skip-networking &
sleep 5

# Créer base et utilisateur
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$USER_PWD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PWD';
FLUSH PRIVILEGES;
EOF

# Arrêter MariaDB temporaire
mysqladmin -u root -p"$ROOT_PWD" shutdown

# Lancer MariaDB (PID 1)
exec mysqld
