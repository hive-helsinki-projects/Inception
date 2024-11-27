#!/bin/bash

# Variables
DOMAIN_NAME="lkilpela.42.fr"
EMAIL="your-email@example.com"

# Install Certbot
apk add --no-cache certbot

# Generate Let's Encrypt certificates
certbot certonly --standalone -d $DOMAIN_NAME --email $EMAIL --agree-tos --no-eff-email --non-interactive

# Copy the certificates to the appropriate directory
mkdir -p /etc/nginx/ssl
cp /etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem /etc/nginx/ssl/nginx.crt
cp /etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem /etc/nginx/ssl/nginx.key

# Set permissions
chmod 600 /etc/nginx/ssl/nginx.crt /etc/nginx/ssl/nginx.key

# Start Nginx
nginx -g "daemon off;"