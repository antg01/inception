# Inception - Docker Project (42)

This project is part of the 42 school curriculum and aims to introduce you to Docker by building a complete containerized infrastructure from scratch.

---

## 📦 What Are Containers?

Containers are lightweight, portable environments that include everything needed to run an application. Unlike virtual machines, they share the host system’s kernel and consume fewer resources.

**Benefits:**

* Fast startup
* Low overhead
* Easy to replicate and deploy
* Run consistently across environments

## 🖥️ Containers vs Virtual Machines

| Feature      | Virtual Machines | Docker Containers      |
| ------------ | ---------------- | ---------------------- |
| OS Included  | Yes              | No (share host kernel) |
| Startup Time | Slow             | Fast                   |
| Disk Usage   | High (GBs)       | Low (MBs)              |
| Portability  | Limited          | Very High              |
| Efficiency   | Low              | High                   |

---

## 🐳 Why Docker?

Imagine your app works fine on your laptop but fails on another machine due to missing dependencies or config. Docker solves this by packaging everything into a container.

## 🧠 Docker Engine Overview

Docker Engine is made of:

* **Docker Daemon:** Manages containers and images.
* **Docker CLI:** Command-line tool to interact with the daemon.
* **Images & Containers:** Built from `Dockerfile`, run as isolated units.

### Basic Workflow

1. Write a `Dockerfile`
2. Build an image: `docker build`
3. Run a container: `docker run`

## 🔧 Dockerfile vs Docker Compose

* **Dockerfile:** Builds one image.
* **Docker Compose:** Defines multiple services (containers) in a YAML file.

### Key Dockerfile Commands

* `FROM`: base image
* `RUN`: run shell commands
* `CMD`: default command to run in the container

### Docker Compose Keywords

* `services`: define containers
* `volumes`: define persistent storage
* `networks`: define communication between services

---

## 🔄 Common Docker Commands

```bash
docker build -t my_image .
docker run -it my_image

docker ps
docker stop <container_id>
docker rm <container_id>
docker rmi <image_id>
docker exec -it <container> bash
docker logs <container>
```

## 🔁 Common Docker Compose Commands

```bash
docker-compose up

docker-compose down
docker-compose build
docker-compose logs
docker-compose exec <service> bash
```

## 🌐 Docker Networks

Docker creates virtual networks so containers can communicate.

Types:

* `bridge`: default
* `host`: shares host network
* `overlay`: multi-host
* `macvlan`: custom IP

```bash
docker network create my-network
```

## 💾 Docker Volumes

Volumes store data outside the container lifecycle.

```bash
docker volume create db-data
docker run -v db-data:/var/lib/mysql mysql
```

---

# 🧩 Inception Services

## MariaDB (Database)

* Uses Debian base image
* Installs and configures MariaDB
* Initializes database and user
* Runs `mysqld_safe` to keep container alive

## WordPress (CMS)

* Uses PHP-FPM and WP-CLI
* Installs WordPress and configures it via CLI
* Connects to MariaDB and runs on port 9000

## NGINX (Web Server)

* Serves WordPress via PHP-FPM
* Uses self-signed TLS cert (OpenSSL)
* Configured for HTTPS with TLSv1.3

## Bonus Services

### Adminer

* Simple PHP DB interface
* Installed with PHP and accessible via browser

### Redis

* In-memory cache for WordPress
* Configured with limited memory and LRU policy
* Integrated into `wp-config.php`

### FTP (vsftpd)

* Adds local FTP user and configures passive mode
* Sets secure permissions for uploaded files

### cAdvisor

* Monitors containers
* Accessible via port `8080`

---

## 📚 Sources

* [Docker Networks – YouTube](https://www.youtube.com/watch?v=bKFMS5C4CG0)
* [WP-CLI – Official Docs](https://developer.wordpress.org/cli/commands/core/)

---
---
Vérifie le protocole TLS en lançant :
> openssl s_client -connect angerard.42.fr:443 -tls1_3 </dev/null 2>/dev/null | grep -i protocol

Liste les volumes :
> docker volume ls

docker volume inspect wordpress
docker volume inspect mariadb

Connecte-toi à MariaDB dans le container :
> docker exec -it mariadb mysql -u root -p
# mot de passe : root_mariadb@pwd!

SHOW DATABASES;
USE my_inception_db;
SHOW TABLES;

Lister les réseaux Docker :
> docker network ls

vérifier l’appartenance des containers :
> docker network inspect inception | grep Name
---
