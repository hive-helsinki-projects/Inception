# Use the official WordPress image as a base
FROM wordpress:php7.4-fpm

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port 80 for php-fpm
EXPOSE 9000

# Start php-fpm
CMD ["php-fpm"]