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
	# Ensure www-data group exists before adding
	getent group www-data || addgroup -S www-data && \
	getent passwd www-data || adduser -S www-data -G www-data && \
	# Create working directory
	mkdir -p /var/www/html && \
	chown -R www-data:www-data /var/www/html && \
	chmod -R 755 /var/www/html && \
	# Ensure the PID file path exists
	mkdir -p /var/run && \
	touch /var/run/php-fpm.pid && \
    chown www-data:www-data /var/run/php-fpm.pid

# Set working directory
WORKDIR /var/www/html

# Install WP-CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x /usr/local/bin/wp

# Set PHP memory limit
RUN echo "memory_limit=256M" >> /etc/php83/php.ini

# Copy configuration and entrypoint script
COPY conf/wp-config.php /var/www/html/wp-config.php
COPY conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# Expose PHP-FPM port
EXPOSE 9000

# Switch to www-data for security
USER www-data

# Run entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm83", "--pid", "/var/run/php-fpm.pid", "-F"]
