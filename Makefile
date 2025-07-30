# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: angerard <angerard@student.s19.be>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/07/23 12:14:52 by angerard          #+#    #+#              #
#    Updated: 2025/07/23 17:53:18 by angerard         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Chemin vers docker-compose
COMPOSE=docker-compose -f ./srcs/docker-compose.yml

# Correction des fins de ligne pour éviter les erreurs d'exécution
fix-permissions:
	@dos2unix srcs/requirements/nginx/tools/init.sh
	@dos2unix srcs/requirements/mariadb/tools/init.sh
	@dos2unix srcs/requirements/wordpress/tools/init.sh

# Création automatique des volumes requis
setup:
	@mkdir -p $(HOME)/data/wordpress
	@mkdir -p $(HOME)/data/mariadb

# Build et lancement
all: fix-permissions setup
	@$(COMPOSE) up -d --build

up:
	@$(COMPOSE) up -d

down:
	@$(COMPOSE) down

start:
	@$(COMPOSE) start

stop:
	@$(COMPOSE) stop

restart:
	@$(COMPOSE) down
	@$(COMPOSE) up -d

rebuild:
	@$(COMPOSE) down
	@$(COMPOSE) build
	@$(COMPOSE) up -d

clean:
	@$(COMPOSE) down -v
	@docker system prune -f

fclean: clean
	@docker volume rm inception_wordpress inception_mariadb 2>/dev/null || true
	@docker image rm nginx:42 wordpress:42 mariadb:42 2>/dev/null || true

ps:
	@docker ps

logs:
	@$(COMPOSE) logs -f

purge-db:
	sudo rm -rf $(HOME)/data/mariadb/*
	sudo chown -R 999:999 $(HOME)/data/mariadb || true

reset-db:
	@echo "Stopping containers and removing database volume..."
	@docker compose down -v
	@docker volume rm mariadb || true
	@echo "✅ MariaDB volume reset. You can now run 'make all'"
