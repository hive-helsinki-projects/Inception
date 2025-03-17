#!/bin/bash
set -e

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

if [ ! -f wp-config.php ]; then
    echo "🔹 WordPress configuration not found. Installing WordPress..."
    
    if [ ! -f index.php ]; then
        wp core download --allow-root
    fi

    wp config create \
        --dbname="$WP_DB_NAME" \
        --dbuser="$WP_DB_USER" \
        --dbpass="$WP_DB_PASSWORD" \
        --dbhost="$WP_DB_HOST" \
        --allow-root

    wp core install \
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
        --allow-root

    echo "✅ WordPress installation complete."
else
    echo "✅ WordPress is already installed. Skipping setup."
fi


# Trap SIGTERM/SIGINT for clean shutdown
trap "echo '🔹 Stopping PHP-FPM...'; kill -QUIT $(cat /var/run/php-fpm.pid); exit 0" SIGTERM SIGINT

echo "🔹 Starting PHP-FPM..."
exec "$@"