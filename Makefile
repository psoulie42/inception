DC = -f ./srcs/docker-compose.yml

all: up

up:
	@if [ -f ./srcs/.env ]; then \
		mkdir -p /home/psoulie/data/; \
		mkdir -p /home/psoulie/data/wordpress; \
		mkdir -p /home/psoulie/data/mariadb; \
		docker compose $(DC) up -d; \
	else \
		echo "./srcs/.env file is missing"; \
	fi

down:
	@docker compose $(DC) down

fclean: down
	sudo rm -rf /home/psoulie/data
	sudo docker volume rm -f srcs_DB
	sudo docker volume rm -f srcs_wordpress
	sudo docker system prune -af

re: fclean up

.PHONY: all up down re fclean
