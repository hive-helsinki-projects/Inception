FROM		alpine:3.19.2

RUN		apk update && apk add --no-cache \
		php82 \
		php82-fpm \
		php82-mysqli \
		php82-json \
		php82-curl \
		php82-dom \
		php82-mbstring \
		php82-openssl \
		php82-xml \
		php82-phar \
		php82-session \
		mariadb-client \
		curl \
		bash

RUN		mkdir -p /var/www/html && \
		cd /usr/local/bin && \
		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
		chmod +x wp-cli.phar && \
		mv wp-cli.phar /usr/bin/wp

COPY		conf/www.conf /etc/php82/php-fpm.d/www.conf

COPY		tools/wordpress-entrypoint.sh /usr/local/bin/wordpress-entrypoint.sh

RUN		chmod +x /usr/local/bin/wordpress-entrypoint.sh

WORKDIR		/var/www/html

EXPOSE		9000

ENTRYPOINT	["/usr/local/bin/wordpress-entrypoint.sh"]

CMD		["php-fpm82", "-F"]