FROM alpine:3.16

RUN apk add --no-cache nginx openssl

# Create self-signed certificate
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 \
    -subj "/CN=${DOMAIN_NAME}" \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/index.html

CMD ["nginx", "-g", "daemon off;"]
