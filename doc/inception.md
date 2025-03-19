# **How Docker and Docker Compose Work**

## **Docker**

- Docker is a platform that allows you to create, deploy, and run applications in containers.
- A container is a lightweight, standalone, and executable package that includes everything needed to run a piece of software, including the code, runtime, libraries, and system tools.
- Docker uses images to create containers. An image is a read-only template with instructions for creating a container.

## **Docker Compose**

- Docker Compose is a tool for defining and running multi-container Docker applications.
- With Docker Compose, you use a YAML file to configure your application's services.
- Then, with a single command, you create and start all the services from your configuration.

## **Difference Between a Docker Image Used with Docker Compose and Without Docker Compose**
- **Without Docker Compose**: You run a single Docker container using the docker run command. This is suitable for simple applications that do not require multiple services.
- **With Docker Compose**: You define multiple services in a `docker-compose.yml` file and run them together using the `docker-compose up` command. This is useful for complex applications that require multiple interconnected services (e.g., a web server, database, and cache).


## Benefit of Docker Compared to VMs
- **Lightweight**: Docker containers share the host system's kernel, making them more lightweight and faster to start compared to virtual machines (VMs), which include a full operating system.
- **Portability**: Docker containers can run on any system that supports Docker, ensuring consistency across different environments (development, testing, production).
- **Efficiency**: Containers use fewer resources than VMs because they share the host OS kernel and do not require a full OS for each instance.

## **Pertinence of the Directory Structure Required for This Project**
The directory structure is crucial for organizing project files and ensuring that Docker and Docker Compose can correctly locate and build services.

```plaintext
.
├── Makefile
├── README.md
├── doc
│   ├── inception.md
│   └── mariadb.md
└── srcs
    ├── docker-compose.yml
    └── requirements
        ├── mariadb
        │   ├── Dockerfile
        │   ├── conf
        │   │   └── my.cnf
        │   └── tools
        │       └── entrypoint.sh
        ├── nginx
        │   ├── Dockerfile
        │   └── conf
        │       └── nginx.conf
        └── wordpress
            ├── Dockerfile
            ├── conf
            │   └── www.conf
            └── tools
                └── entrypoint.sh
```

## **Docker networks**

- Allow containers to communicate with each other, either on the same host or across multiple hosts. They provide isolation and security for containerized applications. Docker supports different network drivers, such as bridge, host, and overlay, each serving different use cases. The bridge driver is commonly used for creating private internal networks on a single Docker host.
    -Docker networks allow containers to communicate with each other, and with the outside world. Here is a simple explanation of the different types of Docker networks listed:

1. **bridge**: The default network driver. Containers connected to this network can communicate with each other, and with the host machine via port mapping.
   - **NETWORK ID**: 7313f2f5139e
   - **NAME**: bridge
   - **DRIVER**: bridge
   - **SCOPE**: local

2. **host**: Removes network isolation between the container and the Docker host. The container shares the host's networking namespace.
   - **NETWORK ID**: 51dd641b396b
   - **NAME**: host
   - **DRIVER**: host
   - **SCOPE**: local

3. **none**: Disables all networking. Containers connected to this network cannot communicate with each other or with the host.
   - **NETWORK ID**: 6cd25083d531
   - **NAME**: none
   - **DRIVER**: null
   - **SCOPE**: local

4. **srcs_inception**: A user-defined bridge network. Similar to the default bridge network but allows for more control over network configuration.
   - **NETWORK ID**: d749ffba304a
   - **NAME**: srcs_inception
   - **DRIVER**: bridge
   - **SCOPE**: local

Each network type serves different use cases depending on the level of isolation and communication required between containers and the host.

## **NGINX with SSL/TLS**

TLS (Transport Layer Security) is a protocol that provides privacy and data integrity between two communicating applications. TLS v1.2 and TLS v1.3 are the two most recent versions of the protocol, offering improved security and performance over previous versions.

### TLS v1.2
- Introduced: August 2008
- Key Features:
Support for stronger cipher suites and hash functions.
Improved performance and security over TLS v1.1.
Support for Perfect Forward Secrecy (PFS) with ephemeral Diffie-Hellman key exchange.
More secure hash algorithms (e.g., SHA-256) for message authentication.
Ability to specify the use of elliptic curve cryptography (ECC).

### TLS v1.3
- Introduced: August 2018
- Key Features:
Simplified handshake process, reducing the number of round trips required to establish a secure connection.
Removal of outdated and insecure cryptographic algorithms (e.g., RSA key exchange, CBC mode ciphers).
Mandatory use of Perfect Forward Secrecy (PFS) for all key exchanges.
Enhanced security with modern cryptographic algorithms (e.g., ChaCha20-Poly1305, AES-GCM).
Improved performance with 0-RTT (Zero Round Trip Time) mode, allowing data to be sent in the first message.

### Self-Signed Certificates
A self-signed certificate is a certificate that is signed by the same entity whose identity it certifies. It is not signed by a trusted Certificate Authority (CA). Self-signed certificates are commonly used for testing, development, and internal purposes where trust can be established through other means.

### Demonstrating TLS v1.2/v1.3 with a Self-Signed Certificate
To demonstrate the use of TLS v1.2/v1.3 with a self-signed certificate, you can configure your web server (e.g., Nginx) to use the self-signed certificate and specify the supported TLS versions.

## **WordPress with phm.fpm & its volumes**

If your WordPress site is hosted at https://lkilpela.42.fr, you can access the login page by navigating to:

`https://lkilpela.42.fr/wp-login.php`

```text
The configuration settings in your www.conf file are essential for managing PHP-FPM (FastCGI Process Manager) processes, which handle PHP requests for your WordPress site. Each setting plays a specific role in ensuring that PHP-FPM operates efficiently and securely. Here is an explanation of why each setting is needed:

### [global] Section

- **error_log = /dev/stderr**: This setting directs PHP-FPM to log errors to the standard error output. Logging errors is crucial for debugging and monitoring the health of your PHP-FPM processes.

### [www] Section

- **user = www-data**: This sets the user under which the PHP-FPM processes will run. Running PHP-FPM under a specific user (e.g., `www-data`) helps manage permissions and enhances security by limiting the access rights of the PHP processes.
- **group = www-data**: This sets the group under which the PHP-FPM processes will run. Similar to the user setting, it helps manage permissions and security.

- **listen = 9000**: This specifies the address and port on which PHP-FPM will listen for incoming FastCGI requests. Port 9000 is commonly used for PHP-FPM, and this setting ensures that PHP-FPM is ready to handle requests from the web server.

- **listen.mode = 0660**: This sets the permissions for the socket used by PHP-FPM. The mode `0660` allows read and write access for the owner and group, ensuring that only authorized users and groups can interact with the PHP-FPM socket.

### Process Management (pm) Settings

- **pm = dynamic**: This setting enables dynamic process management, allowing PHP-FPM to adjust the number of child processes based on the current load. This helps optimize resource usage and ensures that PHP-FPM can handle varying levels of traffic efficiently.

- **pm.max_children = 5**: This sets the maximum number of child processes that PHP-FPM can create. Limiting the number of child processes helps prevent resource exhaustion and ensures that the server remains responsive.

- **pm.start_servers = 2**: This specifies the number of child processes to start with. Having a few child processes ready at startup helps handle initial requests quickly.

- **pm.min_spare_servers = 1**: This sets the minimum number of idle child processes. Maintaining a minimum number of idle processes ensures that PHP-FPM can handle sudden spikes in traffic without delay.

- **pm.max_spare_servers = 3**: This sets the maximum number of idle child processes. Limiting the number of idle processes helps conserve resources while still being prepared for incoming requests.

### Additional Settings

- **catch_workers_output = yes**: This setting captures and logs the output of worker processes. Logging worker output is useful for debugging and monitoring the behavior of individual PHP scripts.

- **php_admin_value[memory_limit] = 256M**: This sets the PHP memory limit for each process to 256 megabytes. Limiting the memory usage of each PHP process helps prevent individual scripts from consuming excessive memory, which could affect the overall performance and stability of the server.

### Summary

These settings are essential for configuring PHP-FPM to handle PHP requests efficiently and securely. They ensure that PHP-FPM runs under the appropriate user and group, listens on the correct port, manages processes dynamically, and logs errors and worker output for monitoring and debugging. Additionally, they help optimize resource usage and prevent resource exhaustion by setting limits on the number of child processes and memory usage.
```

## **MariaDB with its volumes**
1. Access the MariaDB container:

Use the docker exec command to start a shell session in the MariaDB container

`docker exec -it mariadb sh`

2. Log in as the root user:

Once you are inside the MariaDB container, you can use the mysql command-line client to log in to the database.

`mysql -u root -p${MYSQL_ROOT_PASSWORD}`

3. Verify and grant privileges:
```
SHOW GRANTS FOR 'lkilpela'@'%';
GRANT ALL PRIVILEGES ON mydatabase.* TO 'lkilpela'@'%';
FLUSH PRIVILEGES;
```

4. Verify the database is not empty:

To ensure that the database is not empty, you can list the databases and check the tables in the specific database.
```
SHOW DATABASES;
USE mydatabase;
SHOW TABLES;
```

5. Log in as the regular user:

`mysql -u lkilpela -p${MYSQL_PASSWORD}`

These steps ensure that you can log in to the database and verify its contents.

```
The provided configuration file, my.cnf, is used to configure the MySQL server (`mysqld`). This file contains various settings that control the behavior and performance of the MySQL server.

Under the `[mysqld]` section, the basic settings are defined. The `user` directive specifies the system user under which the MySQL server runs, in this case, `mysql`. The `pid-file` directive sets the path to the file where the process ID of the MySQL server is stored. The `socket` directive defines the path to the Unix socket file used for local connections. The `port` directive specifies the port number on which the MySQL server listens for TCP/IP connections, which is set to the default MySQL port, 3306. The `datadir` directive indicates the directory where the MySQL database files are stored. The `skip-external-locking` directive disables external locking, which can improve performance but may not be suitable for all environments.

The `bind-address` directive is used to specify the IP address that the MySQL server listens on. Setting it to `0.0.0.0` allows the server to accept connections from any IP address.

For fine-tuning the server's performance, several directives are included. The `key_buffer_size` directive sets the size of the buffer used for index blocks, which can impact the performance of index handling. The `max_allowed_packet` directive defines the maximum size of a packet or a single SQL statement that the server can handle. The `thread_cache_size` directive specifies the number of threads that the server should cache for reuse, which can reduce the overhead of creating new threads.

Finally, the `log_error` directive specifies the path to the error log file, where the MySQL server logs any errors that occur during its operation. This can be useful for troubleshooting and monitoring the server's health.
```