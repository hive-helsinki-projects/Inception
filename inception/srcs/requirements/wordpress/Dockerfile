FROM alpine:3.16

# Install PHP and php8-fpm
RUN apk add --no-cache php php8-fpm php-mysqli php-json php-openssl php-curl php-dom php-gd

# List installed PHP packages to verify installation
RUN php -v && php-fpm8 -v

# Set up the working directory
WORKDIR /var/www/html

# Copy WordPress configuration (if applicable)
COPY conf/wp-config.php /var/www/html/

# Expose port for php-fpm
EXPOSE 9000

# Start php-fpm
CMD ["php-fpm8", "-F"]