FROM alpine:3.20.6

# Set environment variables for SSL certificate details
ENV SSL_DIR="/etc/nginx/ssl" \
    SSL_DAYS=365 \
    SSL_KEY="/etc/nginx/ssl/nginx.key" \
    SSL_CRT="/etc/nginx/ssl/nginx.crt" \
    SSL_SUBJ="/C=FI/ST=UUSIMA/L=HELSINKI/O=HIVE/OU=HIVE/CN=lkilpela.42.fr"

# Install dependencies, create nginx user/group, and set up SSL
RUN apk add --no-cache nginx openssl \
    && addgroup -S nginx || true \
    && adduser -S -G nginx -g nginx nginx || true \
    && mkdir -p ${SSL_DIR} \
    && chown -R nginx:nginx ${SSL_DIR} \
    && chmod -R 755 ${SSL_DIR} \
    && openssl req -x509 -nodes -days ${SSL_DAYS} -newkey rsa:2048 \
        -keyout ${SSL_KEY} -out ${SSL_CRT} -subj "${SSL_SUBJ}" \
    && chmod 644 ${SSL_KEY}

# Copy custom Nginx configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Expose HTTPS port
EXPOSE 443

# Switch to nginx user for security
USER nginx

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
