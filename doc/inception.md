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
            │   ├── wp-config.php
            │   └── www.conf
            └── tools
                └── entrypoint.sh
```

## **Docker networks**

- Allow containers to communicate with each other, either on the same host or across multiple hosts. They provide isolation and security for containerized applications. Docker supports different network drivers, such as bridge, host, and overlay, each serving different use cases. The bridge driver is commonly used for creating private internal networks on a single Docker host.