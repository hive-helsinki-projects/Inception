FROM alpine:3.16

RUN apk add --no-cache php php-fpm php-mysqli php-json php-openssl php-curl

WORKDIR /var/www/html

COPY conf/wp-config.php /var/www/html/

CMD ["php-fpm", "-F"]
