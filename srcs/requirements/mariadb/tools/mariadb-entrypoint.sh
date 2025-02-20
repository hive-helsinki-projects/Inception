#!/bin/sh
set -e

# MariaDB Data Directory
DATA_DIR="/var/lib/mysql"

# Ensure the socket and log directories exist
SOCKET_DIR="/var/run/mysqld"
LOG_DIR="/var/log/mysql"
mkdir -p "$SOCKET_DIR" "$LOG_DIR"
chown mysql:mysql "$SOCKET_DIR" "$LOG_DIR"

# Debug: Print environment variables
echo "MYSQL_DATABASE: $MYSQL_DATABASE"
echo "MYSQL_USER: $MYSQL_USER"
echo "MYSQL_PASSWORD: $MYSQL_PASSWORD"
echo "MYSQL_ROOT_PASSWORD: $MYSQL_ROOT_PASSWORD"

# Initialize the database if it does not exist
if [ ! -d "$DATA_DIR/mysql" ]; then
    echo 'Initializing database'
    mysql_install_db --user=mysql --datadir=$DATA_DIR > /dev/null
    echo 'Database initialized'

    # Start MariaDB in the background
    mysqld --user=mysql --datadir=$DATA_DIR --skip-networking &
    pid="$!"

    mysql="mysql --protocol=socket -uroot"

    # Wait for MariaDB to start
    for i in $(seq 30 -1 0); do
        if echo 'SELECT 1' | $mysql &> /dev/null; then
            break
        fi
        echo 'MySQL init process in progress...'
        sleep 1
    done

    if [ "$i" = 0 ]; then
        echo >&2 'MySQL init process failed.'
        exit 1
    fi

    # Execute SQL commands to set up the database and user
    $mysql <<-EOSQL
        SET @@SESSION.SQL_LOG_BIN=0;
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` ;
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' ;
        GRANT ALL ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%' ;
        FLUSH PRIVILEGES ;
EOSQL

    # Set the root password if provided
    if [ ! -z "$MYSQL_ROOT_PASSWORD" ]; then
        $mysql <<-EOSQL
            ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
EOSQL
    fi

    # Stop the background MariaDB process
    kill "$pid"
    wait "$pid"
fi

# Execute the command passed to the script
exec "$@"