# Inception

Inception is a project focused on setting up a small infrastructure composed of multiple Docker containers. The objective is to create a multi-service environment using Docker Compose, where each service runs in its own container. The services include an NGINX web server with TLS, a WordPress site with php-fpm, and a MariaDB database.

#### 1. **Environment Setup**
   - Download and install VirtualBox from [VirtualBox's official website](https://www.virtualbox.org/).
   - Download the Alpine Linux ISO from [Alpine Linux's official website](https://alpinelinux.org/downloads/) and attach the ISO to the VM and install Alpine Linux.
   - Install Docker and Docker Compose on your VM.

#### 2. **Project Structure**
   - Create a `srcs` folder to store all configuration files.
   - Ensure your directory structure follows the example provided in the project specifications.

#### 3. **Create a Makefile**
   - Write a Makefile at the root of your directory.
   - The Makefile should build Docker images using `docker-compose.yml`.

#### 4. **Docker Compose Configuration**
   - Create a `docker-compose.yml` file in the `srcs` folder.
   - Define services for NGINX, WordPress, and MariaDB.
   - Ensure each service runs in a dedicated container.
   - Use Alpine or Debian as the base image for your Dockerfiles.

#### 5. **Write Dockerfiles**
   - Create individual Dockerfiles for each service (NGINX, WordPress, MariaDB).
   - Ensure Dockerfiles are called in your `docker-compose.yml` by your Makefile.
   - Avoid using ready-made Docker images (except for Alpine/Debian).

#### 6. **Service Configuration**
   - **NGINX**:
     - Configure NGINX with TLSv1.2 or TLSv1.3.
     - Ensure it is the only entry point via port 443.
   - **WordPress**:
     - Install and configure WordPress with php-fpm.
     - Ensure it runs without NGINX.
   - **MariaDB**:
     - Configure MariaDB with environment variables for root password, database name, user, and password.
     - Ensure it runs without NGINX.

#### 7. **Volumes and Networking**
   - Set up volumes for WordPress database and website files.
   - Create a Docker network to establish connections between containers.
   - Ensure containers restart in case of a crash.

#### 8. **Security and Best Practices**
   - Avoid using hacky patches like `tail -f`, `bash`, `sleep infinity`, or `while true`.
   - Read about PID 1 and best practices for writing Dockerfiles.
   - Use environment variables and store them in a `.env` file located at the root of the `srcs` directory.
   - Ensure no passwords are present in your Dockerfiles.

#### 9. **Domain Configuration**
   - Configure your domain name to point to your local IP address.
   - Use the format `login.42.fr` (replace `login` with your own login).

#### 10. **Testing and Debugging**
   - Test each service individually and as part of the whole application.
   - Use Docker logs and other debugging tools to troubleshoot issues.

## Project Structure

```
.
├── Makefile
├── README.md
└── srcs
    ├── docker-compose.yml
    └── requirements
        ├── mariadb
        │   ├── Dockerfile
        │   ├── conf
        │   │   └── my.cnf
        │   └── mariadb-entrypoint.sh
        ├── nginx
        │   ├── Dockerfile
        │   └── conf
        │       └── nginx.conf
        └── wordpress
            ├── Dockerfile
            ├── conf
            │   └── wp-config
            └── wordpress-entrypoint.sh

```

## Virtual Machine Setup
scp -P 2222 -r /home/lkilpela/Inception localhost:/home/lkilpela

ssh localhost -p 2222
