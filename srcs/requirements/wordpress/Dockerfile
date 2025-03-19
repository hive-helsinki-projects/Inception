# Use Alpine Linux as the base image
FROM alpine:3.20.3

# Install required dependencies in a single RUN layer
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
        bash && \
        # Create nginx user and group
        addgroup -S nginx && \
        adduser -S -G nginx -g nginx nginx && \
        # Create wordpress work directory and set permissions
        mkdir -p /var/www/html && \
        chown -R nginx:nginx /var/www/html && \
        chmod -R 755 /var/www/html && \
        # Install WP-CLI
        curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
        && chmod +x /usr/local/bin/wp

# Set working directory
WORKDIR /var/www/html

# Set PHP memory limit
RUN echo "memory_limit=500M" >> /etc/php83/php.ini

# Copy configuration and entrypoint script
COPY conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# Expose PHP-FPM port
EXPOSE 9000

# Run entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm83", "-F"]