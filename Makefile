WP_DATA    = $(HOME)/data/wordpress
DB_DATA    = $(HOME)/data/mariadb
COMPOSE    = docker compose -f srcs/docker-compose.yml

GREEN = \033[0;32m
RED   = \033[0;31m
RESET = \033[0m

all: setup_dirs
	@echo "$(GREEN)[+] Building and starting containers...$(RESET)"
	$(COMPOSE) up --build -d 

setup_dirs:
	@mkdir -p $(WP_DATA)
	@mkdir -p $(DB_DATA)

mb:
	@echo "$(GREEN) Entering MariaDB container..."
	@docker exec -it mariadb bash

ng:
	@echo "$(GREEN) Entering Nginx container..."
	@docker exec -it nginx bash

wp:
	@echo "$(GREEN) Entering WordPress container..."
	@docker exec -it wordpress bash


down:
	@echo "$(RED)[-] Stopping containers...$(RESET)"
	$(COMPOSE) down

clean: down
	@echo "$(RED)[*] Cleaning up docker system and volumes...$(RESET)"
	docker system prune -af --volumes

fclean: clean
	@echo "$(RED)[*] Removing data folders...$(RESET)"
	@sudo rm -rf $(DB_DATA)
	@sudo rm -rf $(WP_DATA)

re: fclean all