FROM alpine:3.20.3

# Install MariaDB
RUN apk update && \
    apk add --no-cache mariadb mariadb-client mariadb-server-utils

# Create the log directory and set permissions
RUN mkdir -p /var/log/mysql && chown -R mysql:mysql /var/log/mysql \
    && mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld \
    && mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

COPY conf/my.cnf /etc/my.cnf
COPY tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# Expose the default MariaDB port
EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld"]