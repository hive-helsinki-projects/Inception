To test your Docker Compose setup for the MariaDB service, follow these steps:

1. Ensure Docker and Docker Compose are installed: Make sure you have Docker and Docker Compose installed on your system. You can check the installation by running:

```bash
docker --version
docker-compose --version
```

2.Navigate to your project directory: Open a terminal and navigate to the directory containing your `docker-compose.yml` file.

`cd /path/to/your/project`

3. Build the Docker images: Build the Docker images specified in your docker-compose.yml file.

`docker-compose build`

4. Start the services: Start the services defined in your docker-compose.yml file.

`docker-compose up -d`

5. Check the status of the containers: Verify that the containers are running.

`docker-compose ps`

6. Check the logs: View the logs to ensure that the MariaDB service has started correctly and there are no errors.

`docker-compose logs mariadb`

7. Connect to the MariaDB container: Access the MariaDB container to verify the database setup.

`docker exec -it mariadb_container sh`

8. Verify the database and user: Once inside the container, connect to the MariaDB server and check if the database and user have been created correctly.

`mysql -u root -p`

9. Enter the root password (if set) and then run the following SQL commands to verify:
SHOW DATABASES;
SELECT User, Host FROM mysql.user;

10. Clean up: After testing, you can stop and remove the containers.

docker-compose down``