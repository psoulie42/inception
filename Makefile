COMPATH = -f ./srcs/docker-compose.yml

all: up

up: 
	@if [ -f ./srcs/.env ]; then \
		mkdir -p /home/psoulie/data/wordpress; \
		mkdir -p /home/psoulie/data/mariadb; \
		docker compose $(COMPATH) up -d; \
	else \
		echo "srcs/.env file is missing"; \
	fi

down:
	@docker compose -f $(COMPATH) down

fclean: down
	sudo rm -rf /home/psoulie/data
	sudo docker volume rm -f srcs_DB
	sudo docker volume rm -f srcs_wordpress
	sudo docker system prune -af

re: fclean up

.PHONY: all up down fclean re

