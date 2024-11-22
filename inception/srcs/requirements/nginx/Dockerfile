# Use an official NGINX image as a base
FROM nginx:latest

# Copy NGINX configuration files
COPY ./conf /etc/nginx/conf/nginx.conf
COPY ./certs /etc/nginx/certs


# Expose port 443 for HTTPS
EXPOSE 443

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
