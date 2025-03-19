FROM	alpine:3.20.3

RUN addgroup -S nginx && \
    adduser -S -G nginx -g nginx nginx

RUN apk update && apk add --no-cache \
    nginx \
    openssl && \
    mkdir -p /etc/nginx/ssl && \
    chown -R nginx:nginx /etc/nginx/ssl  && \
    chmod -R 755 /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FI/ST=UUSIMA/L=HELSINKI/O=HIVE/OU=HIVE/CN=lkilpela.42.fr" && \
    chmod 644 /etc/nginx/ssl/nginx.key

COPY conf/nginx.conf /etc/nginx/nginx.conf

USER nginx

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]