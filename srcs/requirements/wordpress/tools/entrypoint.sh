#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status.

wait_for_mariadb() {
    echo "🔹 Waiting for MariaDB to be ready..."
    TIMEOUT=120
    ELAPSED=0

    while ! mysqladmin ping -h"$WP_DB_HOST" --silent; do
        if [ "$ELAPSED" -ge "$TIMEOUT" ]; then
            echo "❌ Error: MariaDB is not ready after $TIMEOUT seconds. Exiting..."
            exit 1
        fi
        echo "⏳ MariaDB is unavailable - retrying in 5 seconds..."
        sleep 5
        ELAPSED=$((ELAPSED + 5))
    done

    echo "✅ MariaDB is ready!"
}

install_wordpress() {
    echo "🔹 Checking for WordPress installation..."
    
    if [ ! -f wp-config.php ]; then
        echo "🔹 WordPress configuration not found. Proceeding with installation..."
        
        # Ensure core files exist
        wp core download --allow-root --quiet
        
        # Create wp-config.php
        wp config create \
            --dbname="$WP_DB_NAME" \
            --dbuser="$WP_DB_USER" \
            --dbpass="$WP_DB_PASSWORD" \
            --dbhost="$WP_DB_HOST" \
            --allow-root
        
        # Install WordPress
        wp core install \
            --url="$WP_URL" \
            --title="$WP_TITLE" \
            --admin_user="$WP_ADMIN_USER" \
            --admin_password="$WP_ADMIN_PASSWORD" \
            --admin_email="$WP_ADMIN_EMAIL" \
            --allow-root
        
        # Create an additional user
        wp user create \
            "$WP_USER" "$WP_USER_EMAIL" \
            --role=author \
            --user_pass="$WP_USER_PASSWORD" \
            --allow-root
        
        echo "✅ WordPress installation complete."
    else
        echo "✅ WordPress is already installed. Skipping setup."
    fi
}

# Start the script
wait_for_mariadb
install_wordpress

echo "🚀 Starting PHP-FPM..."
exec "$@"
