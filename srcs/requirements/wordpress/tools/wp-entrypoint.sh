#!/bin/bash

if [ ! -f "/var/www/html/wp-includes/version.php" ]; then
	wp core download --allow-root --path='/var/www/html'
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html
fi

if [ ! -f "/var/www/html/wp-config.php" ]; then
	wp config create --allow-root --dbname=$SQL_DATABASE --dbuser=$SQL_USER --dbpass=$SQL_PASSWORD --dbhost=$SQL_HOST:3306 --path='/var/www/html'
	wp core install --allow-root --url=$DOMAIN_NAME --title="42 Inception "$DOMAIN_NAME --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --path='/var/www/html'
	wp user create --allow-root $WP_USER $WP_EMAIL --role=author --user_pass=$WP_PASSWORD --path='/var/www/html'
	wp menu create "Main Menu" --allow-root --path='/var/www/html'
	wp menu item add-custom "Main Menu" "Login" "/wp-login.php" --allow-root --path='/var/www/html'
fi

exec /usr/sbin/php-fpm8.2 -F