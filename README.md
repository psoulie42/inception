*This project has been created as part of the 42 curriculum by psoulie*

---

## Description

**Inception** is a system administration and DevOps-oriented project focused on containerization using Docker.

The goal of this project is to build a small infrastructure composed of multiple services running in isolated containers. These services are orchestrated using Docker Compose, and each container must follow strict rules (e.g., no pre-built images except Alpine/Debian, proper networking, volume usage, etc.).

### Objectives

- Learn how to use Docker to containerize applications
- Understand service orchestration with Docker Compose
- Configure and manage multiple interconnected services
- Implement secure and maintainable infrastructure

### Project Architecture

The infrastructure includes:

- NGINX (reverse proxy with TLS)
- WordPress (PHP application)
- MariaDB (database)

Each service runs in its own container and communicates through a Docker network.

---

## Instructions

### Requirements

- Docker & Docker Compose installed

### Setup & Run

A makefile is provided at the root of the repository to manage the entire lifecycle of the application:

* `make up`: Automatically creates required host directories, builds the images, and starts the containers.
* `make down`: Stops all running containers.
* `make fclean`: Performs a full cleanup, including the deletion of persistent data in `/home/squement/data`.
* `make re`: Restarts the entire build and deployment process.

---

## Project Design & Technical Choices

### Why Docker?

Docker allows lightweight, reproducible environments compared to traditional virtualization. It ensures consistency across development and deployment.

---

### Virtual Machines vs Docker

| Virtual Machines | Docker |
|-----------------|--------|
| Full OS per instance | Shared host kernel |
| Heavy resource usage | Lightweight |
| Slow startup | Fast startup |
| Strong isolation | Process-level isolation |

---

### Secrets vs Environment Variables

| Secrets | Environment Variables |
|--------|----------------------|
| Secure storage | Plain text |
| Not exposed in logs | Can leak |
| Managed by Docker | Manually handled |

---

### Docker Network vs Host Network

| Docker Network | Host Network |
|---------------|-------------|
| Isolated containers | Shares host network |
| Internal DNS support | No isolation |
| Safer | Less secure |

---

### Docker Volumes vs Bind Mounts

| Volumes | Bind Mounts |
|--------|-------------|
| Managed by Docker | Direct host access |
| Portable | Host-dependent |
| Safer | More flexible |

---

## Sources Included

- Custom Dockerfiles for each service
- docker-compose.yml for orchestration
- NGINX configuration (TLS setup)
- WordPress and database initialization scripts

---

## Resources

### Documentation & Tutorials

- Docker documentation  
- NGINX documentation  
- WordPress documentation  
- MariaDB documentation  

### Learning Resources

- Docker Compose guides and best practices  
- Linux system administration basics  
- Networking fundamentals (ports, DNS, reverse proxy)  

---

### AI Usage

AI tools were used in the following ways:

- Making this readme

---

## Features

- Multi-container architecture  
- Secure HTTPS setup with NGINX  
- Persistent database using volumes  
- Environment-based configuration  
- Modular and extensible design  

---

## Additional Notes

- This project follows strict 42 requirements (no pre-built images except base OS)  
- Containers are built from scratch using Dockerfiles  
- Emphasis on security, isolation, and reproducibility  
