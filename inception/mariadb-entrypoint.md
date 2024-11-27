# Explanation of `mariadb-entrypoint.sh`

This script is an entry point for initializing and starting a MariaDB server. Here's a step-by-step explanation of what it does and why:

1. **Shebang and Error Handling**:
   ```shell
   #!/bin/bash
   set -e
   ```

    - `#!/bin/bash`: Specifies that the script should be run using the Bash shell.
    - `set -e`: Ensures the script exits immediately if any command exits with a non-zero status.

2. **Check for Existing Data Directory**:
    ```shell
    if [ ! -d "/var/lib/mysql/mysql" ]; then
    ```
    - Checks if the MariaDB data directory does not exist. If it doesn't, it proceeds to initialize it.

3. **Initialize Data Directory**:

mysql_install_db: Initializes the MariaDB data directory with the necessary system tables.
Bootstrap MariaDB:

Starts the MariaDB server in bootstrap mode to execute initialization SQL commands.
FLUSH PRIVILEGES;: Reloads the privilege tables.
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';: Sets the root password.
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;: Creates a database if it doesn't exist.
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';: Creates a new user with the specified password.
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';: Grants all privileges on the new database to the new user.
DELETE FROM mysql.user WHERE User='';: Removes anonymous users.
DROP DATABASE IF EXISTS test;: Removes the test database if it exists.
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';: Removes any test database entries.
FLUSH PRIVILEGES;: Reloads the privilege tables again to ensure all changes take effect.
Start MariaDB Server:

Prints a message indicating the server is starting.
exec "$@": Replaces the current shell with the command specified in the script's arguments, typically the MariaDB server process.
This script ensures that MariaDB is properly initialized and configured before starting the server, making it ready for use with the specified database and user credentials.