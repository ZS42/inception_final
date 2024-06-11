#!/bin/sh

# Create the directory to store the wordpress if not created
if [ ! -d /var/www/ ]; then
    mkdir -p /var/www/
fi

cd /var/www/

# Download the latest version of wordpress
wget https://wordpress.org/latest.zip
unzip latest.zip
cp -rf wordpress/* ./
rm -rf wordpress latest.zip

# Set the database credentials
if [ ! -f ./wp-config.php ]; then
    cp ./wp-config-sample.php ./wp-config.php
    sed -i "s|database_name_here|${DB_NAME}|g" ./wp-config.php
    sed -i "s|username_here|${DB_USER}|g" ./wp-config.php
    sed -i "s|password_here|${DB_PASS}|g" ./wp-config.php
    sed -i "s|localhost|mariadb|g" ./wp-config.php
fi

# Dowload the wp-cli and turnn it executable and move it
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Install wordpress and create the admin and user
sleep 5
wp core install  --url="$DOMAIN_NAME" --title="$TITLE" --admin_user="$WPADUSER" --admin_password="$WPADPASS" --admin_email="$WPAD_EMAIL"
wp user create "$WPUSER1" "$WPUSER1_EMAIL" --role=subscriber --user_pass="$WPUSER1PASS"

# wp theme install hey --activate --allow-root
chown -R www-data:www-data /var/www/wp-content
chmod -R 755 /var/www/wp-content
mkdir -p /var/www/wp-content/upgrade/
wp theme install hey --activate --allow-root

# Run the php-fpm daemon
php-fpm81 -FR