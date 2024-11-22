# Use an official NGINX image as a base
FROM nginx:1.21.6

# Copy NGINX configuration files
COPY ./conf /etc/nginx/conf
COPY ./certs /etc/nginx/certs


# Expose port 443 for HTTPS
EXPOSE 443

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
