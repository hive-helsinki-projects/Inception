FROM alpine:3.20.3

# Install MariaDB and MariaDB client
RUN apk add --no-cache mariadb mariadb-client

# Create the log directory and set permissions
RUN mkdir -p /var/log/mysql && chown mysql:mysql /var/log/mysql

# Copy configuration and entrypoint script
COPY --chown=mysql:mysql conf/my.cnf /etc/my.cnf
COPY --chown=mysql:mysql tools/mariadb-entrypoint.sh /usr/local/bin/mariadb-entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/mariadb-entrypoint.sh

# Define the volume for MariaDB data
VOLUME ["/var/lib/mysql"]

# Expose the default MariaDB port
EXPOSE 3306

# Set the entrypoint and default command
ENTRYPOINT ["mariadb-entrypoint.sh"]
CMD ["mysqld"]