FROM alpine:3.16

RUN apk add --no-cache nginx openssl

COPY certs/ /etc/nginx/certs/
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/index.html

# Expose port 443
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
