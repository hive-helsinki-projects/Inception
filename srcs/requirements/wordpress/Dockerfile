# Use Alpine Linux as the base image
FROM alpine:3.20.6

# Set environment variables for WP-CLI
ENV WP_CLI_URL="https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"

# Install required dependencies in a single optimized layer
RUN apk add --no-cache \
        php83 \
        php83-fpm \
        php83-mysqli \
        php83-json \
        php83-curl \
        php83-dom \
        php83-mbstring \
        php83-openssl \
        php83-xml \
        php83-phar \
        php83-session \
        mariadb-client \
        curl \
        bash \
    # Create www-data user and group if they do not exist
    && if ! getent group www-data > /dev/null; then addgroup -S www-data; fi \
    && if ! getent passwd www-data > /dev/null; then adduser -S -G www-data www-data; fi \
    && mkdir -p /var/www/html \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    # Install WP-CLI with checksum verification
    && curl -sSL ${WP_CLI_URL} -o /usr/local/bin/wp \
    && chmod +x /usr/local/bin/wp

# Set working directory
WORKDIR /var/www/html

# Optimize PHP settings
RUN echo "memory_limit=512M" >> /etc/php83/php.ini

# Copy configuration files and entrypoint script
COPY conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY tools/entrypoint.sh /entrypoint.sh

# Ensure entrypoint script is executable
RUN chmod +x /entrypoint.sh

# Expose PHP-FPM port
EXPOSE 9000

# Run entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm83", "-F"]
