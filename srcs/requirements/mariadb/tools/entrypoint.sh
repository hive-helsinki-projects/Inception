#!/bin/sh

# Function to initialize the database if empty
initialize_database() {
    echo "🔹 Initializing database..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    mysqld --user=mysql --bootstrap <<EOF
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
GRANT CREATE USER ON *.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    echo "✅ Database initialized with user '${MYSQL_USER}' and database '${MYSQL_DATABASE}'."
}

# Function to grant privileges for WordPress
grant_wp_privileges() {
    echo "🔹 Granting privileges to ${WP_DB_USER} on ${WP_DB_NAME}..."
    
    mysqld --user=mysql --bootstrap <<EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS ${WP_DB_NAME};
CREATE USER IF NOT EXISTS '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    echo "✅ Privileges granted to '${WP_DB_USER}' on database '${WP_DB_NAME}'."
}

# Initialize the database if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    initialize_database
else
    echo "🔹 Database already initialized."
fi

# Grant privileges for WordPress
grant_wp_privileges

# Start the MariaDB server
echo "🔹 Starting MariaDB server..."
exec mysqld --user=mysql --datadir=/var/lib/mysql
