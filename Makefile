# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: angerard <angerard@student.s19.be>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/07/23 12:14:52 by angerard          #+#    #+#              #
#    Updated: 2025/07/23 12:34:04 by angerard         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Chemin vers docker-compose
COMPOSE=docker-compose -f ./srcs/docker-compose.yml

# Cibles principales
all:
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
