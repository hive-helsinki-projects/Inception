#!/bin/bash
set -e

# Define the target directory
WORDPRESS_PATH="/var/www/html/data"

mkdir -p "$WORDPRESS_PATH"
cd "$WORDPRESS_PATH"

# Debugging: Print environment variables
echo "🔹 Environment Variables:"
echo "WP_URL: $WP_URL"
echo "WP_TITLE: $WP_TITLE"
echo "WP_ADMIN_USER: $WP_ADMIN_USER"
echo "WP_ADMIN_PASSWORD: $WP_ADMIN_PASSWORD"
echo "WP_ADMIN_EMAIL: $WP_ADMIN_EMAIL"
echo "WP_USER: $WP_USER"
echo "WP_USER_EMAIL: $WP_USER_EMAIL"
echo "WP_USER_PASSWORD: $WP_USER_PASSWORD"
echo "WP_DB_HOST: $WP_DB_HOST"
echo "WP_DB_NAME: $WP_DB_NAME"
echo "WP_DB_USER: $WP_DB_USER"
echo "WP_DB_PASSWORD: $WP_DB_PASSWORD"

wait_for_mariadb() {
    echo "🔹 Waiting for MariaDB to be ready..."
    TIMEOUT=60
    ELAPSED=0
    while ! mysqladmin ping -h"$WP_DB_HOST" --silent; do
        if [ "$ELAPSED" -ge "$TIMEOUT" ]; then
            echo "❌ Error: MariaDB is not ready after $TIMEOUT seconds. Exiting..."
            exit 1
        fi
        echo "MariaDB is unavailable - sleeping"
        sleep 10
        ((ELAPSED+=5))
    done
    echo "✅ MariaDB is ready!"
}

# Validate admin username
if echo "$WP_ADMIN_USER" | grep -qiE 'admin|administrator'; then
    echo "❌ Error: Admin username cannot contain 'admin' or 'administrator'. Exiting..."
    exit 1
fi

wait_for_mariadb

WORDPRESS_PATH="/var/www/html/wordpress"

mkdir -p "$WORDPRESS_PATH"
cd "$WORDPRESS_PATH"

if [ ! -f wp-config.php ]; then
    echo "🔹 WordPress configuration not found. Installing WordPress..."
    
    if [ ! -f index.php ]; then
        wp core download --path="$WORDPRESS_PATH" --allow-root
    fi

    wp config create \
        --path="$WORDPRESS_PATH" \
        --dbname="$WP_DB_NAME" \
        --dbuser="$WP_DB_USER" \
        --dbpass="$WP_DB_PASSWORD" \
        --dbhost="$WP_DB_HOST" \
        --allow-root

    wp core install \
        --path="$WORDPRESS_PATH" \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root

    wp user create \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$WP_USER_PASSWORD" \
        --path="$WORDPRESS_PATH" \
        --allow-root

    echo "✅ WordPress installation complete in $WORDPRESS_PATH!"
else
    echo "✅ WordPress is already installed in $WORDPRESS_PATH. Skipping setup."
fi

# Secure wp-config.php
if [ -f "$WORDPRESS_PATH/wp-config.php" ]; then
    echo "🔹 Securing wp-config.php..."
    chown www-data:www-data "$WORDPRESS_PATH/wp-config.php" || echo "⚠️ Warning: Unable to change ownership"
    chmod 600 "$WORDPRESS_PATH/wp-config.php"
fi

# Trap SIGTERM/SIGINT for clean shutdown
trap "echo '🔹 Stopping PHP-FPM...'; kill -QUIT $(cat /var/run/php-fpm.pid); exit 0" SIGTERM SIGINT

echo "🔹 Starting PHP-FPM..."
exec "$@"
i