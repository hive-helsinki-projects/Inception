#!/bin/bash
set -e

wait_for_mariadb() {
	echo "Waiting for MariaDB to be ready..."
	while ! mysqladmin ping -h"$WP_DB_HOST" -u"$WP_DB_USER" -p"$WP_DB_PASSWORD" --silent; do
		echo "MariaDB is unavailable - sleeping"
		sleep 5
	done
	echo "MariaDB is up and running!"
}

wait_for_mariadb

if [ ! -f wp-config.php ]; then
	echo "WordPress configuration not found. Installing WordPress..."
	if [ ! -f index.php ]; then
		wp core download --allow-root
	fi
	
	wp config create \
		--dbname=$WP_DB_NAME \
		--dbuser=$WP_DB_USER \
		--dbpass=$WP_DB_PASSWORD \
		--dbhost=$WP_DB_HOST \
		--allow-root
	wp core install \
		--url=$WP_URL \
		--title=$WP_TITLE \
		--admin_user=$WP_ADMIN_USER \
		--admin_password=$WP_ADMIN_PASSWORD \
		--admin_email=$WP_ADMIN_EMAIL \
		--allow-root
	wp user create \
		$WP_USER \
		$WP_USER_EMAIL \
		--role=author \
		--user_pass=$WP_USER_PASSWORD \
		--allow-root
	echo "WordPress installation complete!"
else
	echo "Wordpress already installed."
fi

echo "Starting PHP-FPM"
exec "$@"
