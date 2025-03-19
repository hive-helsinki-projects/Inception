FROM alpine:3.20.6

# Set MariaDB environment variables
ENV MYSQL_DATA_DIR=/var/lib/mysql \
    MYSQL_LOG_DIR=/var/log/mysql \
    MYSQL_RUN_DIR=/var/run/mysqld

# Install MariaDB in a single optimized layer
RUN apk add --no-cache mariadb mariadb-client mariadb-server-utils \
    && mkdir -p ${MYSQL_DATA_DIR} ${MYSQL_LOG_DIR} ${MYSQL_RUN_DIR} \
    && chown -R mysql:mysql ${MYSQL_DATA_DIR} ${MYSQL_LOG_DIR} ${MYSQL_RUN_DIR} \
    && chmod 700 ${MYSQL_DATA_DIR} ${MYSQL_LOG_DIR} ${MYSQL_RUN_DIR}

# Copy configuration and entrypoint script
COPY conf/my.cnf /etc/my.cnf
COPY tools/entrypoint.sh /entrypoint.sh

# Ensure entrypoint script is executable
RUN chmod +x /entrypoint.sh

# Expose the default MariaDB port
EXPOSE 3306

# Run MariaDB with entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld"]
