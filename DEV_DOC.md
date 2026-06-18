# DEV_DOC — Developer Documentation

## Overview

This project (Inception) sets up a small infrastructure composed of three Docker containers orchestrated with Docker Compose:

| Container | Role |
|---|---|
| **nginx** | Reverse proxy, handles HTTPS (port 443) |
| **wordpress** | PHP-FPM application server (port 9000 internally) |
| **mariadb** | MySQL-compatible database |

All containers run on a dedicated bridge network (`inception`) and share data through named volumes bound to the host filesystem.

---

## Prerequisites

Make sure the following tools are installed on your machine before getting started:

- **Docker** (≥ 24.x recommended)
- **Docker Compose** plugin (`docker compose`, not the legacy `docker-compose`)
- **make**
- **sudo** access (required for volume cleanup)

---

## Project Structure

```
.
├── Makefile
└── srcs/
    ├── .env                        # Environment variables (secrets) — not committed
    ├── docker-compose.yml
    └── requirements/
        ├── nginx/
        │   └── Dockerfile
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── conf/www.conf       # PHP-FPM pool configuration
        │   └── tools/wp-entrypoint.sh
        └── mariadb/
            └── Dockerfile
```

---

## Configuration & Secrets

The project relies on a `.env` file located at `srcs/.env`. **This file is not included in the repository and must be created manually before the first launch.**

Create `srcs/.env` and fill in the following variables:

```env
# MariaDB
SQL_ROOT_PASSWORD=your_root_password
SQL_DATABASE=your_database_name
SQL_USER=your_db_user
SQL_PASSWORD=your_db_password

# WordPress
DOMAIN_NAME=your_domain_or_login.42.fr
WP_ADMIN_USER=your_wp_admin
WP_ADMIN_PASSWORD=your_wp_admin_password
WP_ADMIN_EMAIL=your_wp_admin@email.com
WP_USER=your_wp_user
WP_USER_PASSWORD=your_wp_user_password
WP_USER_EMAIL=your_wp_user@email.com

# Host user (used for volume paths)
USER=your_linux_username
```

> **Never commit `.env` to version control.** It contains sensitive credentials.

---

## Building & Launching the Project

All workflow commands go through the `Makefile` at the project root.

### First launch

```bash
make
# or equivalently:
make up
```

This command will:
1. Check that `srcs/.env` exists (exits with an error message if not).
2. Create the host data directories:
   - `/home/<USER>/data/wordpress`
   - `/home/<USER>/data/mariadb`
3. Build all Docker images from their respective Dockerfiles.
4. Start all containers in detached mode (`-d`).

> The `mariadb` healthcheck runs automatically. WordPress will only start once MariaDB is confirmed healthy (via `mysqladmin ping`).

### Stop the containers

```bash
make down
```

Stops and removes the containers. **Volumes and data on the host are preserved.**

### Full reset (clean slate)

```bash
make fclean
```

This will:
- Stop and remove all containers (`down`).
- Delete all host data directories (`/home/<USER>/data`).
- Force-remove the Docker volumes `srcs_DB` and `srcs_wordpress`.
- Prune all unused Docker images, networks, and build cache (`docker system prune -af`).

> ⚠️ `fclean` is destructive. All WordPress files and database data will be permanently deleted.

### Rebuild from scratch

```bash
make re
```

Equivalent to running `make fclean` followed by `make up`. Use this after making changes to a Dockerfile or configuration file.

---

## Managing Containers

Once the stack is running, you can use standard Docker commands to inspect or interact with individual containers.

```bash
# List running containers
docker ps

# View logs for a specific service
docker compose -f ./srcs/docker-compose.yml logs -f nginx
docker compose -f ./srcs/docker-compose.yml logs -f wordpress
docker compose -f ./srcs/docker-compose.yml logs -f mariadb

# Open a shell inside a container
docker exec -it nginx sh
docker exec -it wordpress bash
docker exec -it mariadb bash

# Restart a single service
docker compose -f ./srcs/docker-compose.yml restart wordpress

# Check MariaDB health manually
docker exec -it mariadb mysqladmin ping -h localhost -u root -p
```

---

## Data Persistence

Data is stored on the **host machine** and mounted into the containers as bind-mount volumes. This means data survives container restarts and even `make down`.

| Volume name | Host path | Container path | Used by |
|---|---|---|---|
| `wordpress` | `/home/<USER>/data/wordpress` | `/var/www/html` | nginx, wordpress |
| `DB` | `/home/<USER>/data/mariadb` | `/var/lib/mysql` | mariadb |

Both services (`nginx` and `wordpress`) share the same `wordpress` volume so that nginx can serve static assets directly from the same filesystem that PHP-FPM writes to.

> Data is only deleted when you run `make fclean` or manually remove the host directories.

---

## Networking

All three containers communicate over a dedicated Docker bridge network named `inception`. Containers reference each other by their **container name** (e.g., WordPress connects to `mariadb`, nginx proxies to `wordpress:9000`).

Port **443** is the only port exposed to the host, handled exclusively by nginx.

---

## Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `./srcs/.env file is missing` on `make up` | `.env` not created | Create `srcs/.env` (see above) |
| WordPress container exits immediately | MariaDB not ready | Wait for healthcheck to pass; check `docker logs mariadb` |
| Permission error on data directories | Wrong `USER` in `.env` | Ensure `USER` matches your actual Linux username |
| Changes to Dockerfile not reflected | Cached image in use | Run `make re` to rebuild from scratch |
