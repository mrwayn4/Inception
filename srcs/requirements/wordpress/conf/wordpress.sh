#!/bin/bash

# ----------------- VARIABLES -----------------
WP_DIR="/var/www/wordpress"
WP_CLI_BIN="/usr/local/bin/wp"

# ----------------- STEP 1: WAIT FOR MARIADB -----------------
echo "[INFO] Waiting for MariaDB to start..."
sleep 10

# ----------------- STEP 2: PREPARE WORDPRESS DIRECTORY -----------------
echo "[INFO] Creating WordPress directory at $WP_DIR..."
mkdir -p "$WP_DIR"
rm -rf "$WP_DIR"/*

echo "[INFO] Setting directory permissions..."
chmod -R 755 "$WP_DIR"

# ----------------- STEP 3: INSTALL WP-CLI -----------------
echo "[INFO] Downloading WP-CLI..."
curl -s -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

echo "[INFO] Installing WP-CLI..."
chmod +x wp-cli.phar && mv wp-cli.phar "$WP_CLI_BIN"

# ----------------- STEP 4: DOWNLOAD WORDPRESS -----------------
echo "[INFO] Downloading WordPress core files..."
wp core download --path="$WP_DIR" --allow-root

# ----------------- STEP 5: CONFIGURE WORDPRESS -----------------
echo "[INFO] Creating wp-config.php file..."
mv "$WP_DIR/wp-config-sample.php" "$WP_DIR/wp-config.php"

echo "[INFO] Setting database credentials in config..."
wp config set DB_NAME ${MYSQL_DB} --path="$WP_DIR" --allow-root
wp config set DB_USER ${MYSQL_USER} --path="$WP_DIR" --allow-root
wp config set DB_PASSWORD ${MYSQL_USER_PASS} --path="$WP_DIR" --allow-root
wp config set DB_HOST "mariadb:3306" --path="$WP_DIR" --allow-root

# ----------------- STEP 6: INSTALL WORDPRESS -----------------
echo "[INFO] Installing WordPress site..."
wp core install \
  --url="${WP_DN}" \
  --title="${WP_TITLE}" \
  --admin_user="${WP_ADMIN}" \
  --admin_password="${WP_ADMIN_PASS}" \
  --admin_email="${WP_ADMIN_EMAIL}" \
  --skip-email \
  --path="$WP_DIR" --allow-root

# ----------------- STEP 7: ADD NORMAL USER -----------------
echo "[INFO] Creating regular WordPress user..."
wp user get ${WP_USER} --path="$WP_DIR" --allow-root || \
wp user create ${WP_USER} ${WP_USER_EMAIL} \
  --user_pass=${WP_USER_PASS} \
  --role=${WP_USER_ROLE} \
  --path="$WP_DIR" --allow-root


# ----------------- STEP 5: CONFIGURE REDIS -----------------
echo "[INFO] Enabling Redis configuration in WordPress..."
wp config set WP_CACHE true --path="$WP_DIR" --allow-root
wp config set WP_REDIS_HOST "redis" --path="$WP_DIR" --allow-root
wp config set WP_REDIS_PORT 6379 --path="$WP_DIR" --allow-root


# ----------------- STEP 8: PLUGINS & THEMES -----------------
echo "[INFO] Installing and activating Redis Cache plugin..."
wp plugin install redis-cache --activate --path="$WP_DIR" --allow-root
wp redis enable --path="$WP_DIR" --allow-root

echo "[INFO] Installing default theme (twentytwentytwo)..."
wp theme install twentytwentytwo --activate --path="$WP_DIR" --allow-root

# ----------------- STEP 10: PHP-FPM -----------------
echo "[INFO] Updating PHP-FPM to listen on port 9000..."
sed -i 's|^listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

echo "[INFO] Ensuring /run/php directory exists..."
mkdir -p /run/php

echo "[✓] WordPress setup is complete! Starting PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F
