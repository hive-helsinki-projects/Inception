FROM alpine:3.19.2

# Combine RUN commands to reduce layers
RUN apk update && apk add --no-cache \
    mariadb \
    mariadb-client \
    mariadb-common \
    bash && \
    mkdir -p /run/mysqld /var/lib/mysql /var/log/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql /var/log/mysql

# Copy configuration and entrypoint script
COPY conf/my.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY tools/mariadb-entrypoint.sh /usr/local/bin/

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/mariadb-entrypoint.sh

# Expose the default MySQL port
EXPOSE 3306

# Set the entrypoint and default command
ENTRYPOINT ["mariadb-entrypoint.sh"]
CMD ["mysqld", "--user=mysql"]