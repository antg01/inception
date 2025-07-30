#!/bin/sh
set -ex

# Load secrets
db_name_file=/secrets/db_name.txt
db_user_file=/secrets/db_user.txt
db_pwd_file=/secrets/db_password.txt
db_root_pwd_file=/secrets/db_root_password.txt

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
    USER_PWD=$(cat "$db_pwd_file")
fi

if [ -f "$db_root_pwd_file" ]
then
    ROOT_PWD=$(cat "$db_root_pwd_file")
fi

# Start MariaDB in background
mysqld_safe --datadir=/var/lib/mysql &

# Wait until DB is ready
while ! mysqladmin ping --silent --password="$ROOT_PWD" --user=root; do
    sleep 1
done

# Create database and user
mysql -u root -p"$ROOT_PWD" <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$USER_PWD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF

# Keep MariaDB running
wait
