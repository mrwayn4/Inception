#!/bin/bash

echo "Launching MariaDB service..."
service mariadb start

echo "Giving MariaDB some time to boot up..."
sleep 5

echo "Configuring root password for MariaDB..."
mysqladmin -u root password "${MYSQL_ROOT_PASS}"

echo "Checking and creating database '${MYSQL_DB}' if missing..."
mysql -u root -p"${MYSQL_ROOT_PASS}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;"

echo "Adding user "${MYSQL_USER}" if they don't already exist..."
mysql -u root -p"${MYSQL_ROOT_PASS}" -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_USER_PASS}';"

echo "Assigning full access on '${MYSQL_DB}' to user '${MYSQL_USER}'..."
mysql -u root -p"${MYSQL_ROOT_PASS}" -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DB}\`.* TO \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_USER_PASS}';"

echo "Reloading privilege tables..."
mysql -u root -p"${MYSQL_ROOT_PASS}" -e "FLUSH PRIVILEGES;"

echo "Halting MariaDB service..."
service mariadb stop

echo "Starting MariaDB in safe mode to allow external connections..."
exec mysqld_safe --bind-address=0.0.0.0