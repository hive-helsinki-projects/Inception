DC                  = cd srcs && docker compose
VOLUME_PATH         = /home/lkilpela/data
WORDPRESS_VOLUME    = $(VOLUME_PATH)/wordpress
MARIADB_VOLUME      = $(VOLUME_PATH)/mariadb
DOMAIN              = lkilpela.42.fr

all: setup build up

setup:
	@echo "Creating required data directories..."
	@mkdir -p $(WORDPRESS_VOLUME) $(MARIADB_VOLUME)
	@if ! grep -q "$(DOMAIN)" /etc/hosts; then \
		echo "Adding $(DOMAIN) to /etc/hosts"; \
		echo "127.0.0.1 $(DOMAIN)" | sudo tee -a /etc/hosts; \
	fi

build:
	@echo "Building Docker images..."
	@$(DC) build

up:
	@echo "Starting containers..."
	@$(DC) up -d

down:
	@echo "Stopping and removing containers..."
	@$(DC) down

logs:
	@echo "Displaying logs..."
	@$(DC) logs -f

ps:
	@echo "Listing running containers..."
	@$(DC) ps

clean:
	@echo "Removing volumes and Docker resources..."
	@sudo rm -rf $(WORDPRESS_VOLUME) $(MARIADB_VOLUME)
	@docker stop $$(docker ps -q) 2>/dev/null || true
	@docker rm $$(docker ps -aq) 2>/dev/null || true
	@docker rmi $$(docker images -q) 2>/dev/null || true
	@docker volume prune -f
	@docker network prune -f

restart: down build up

.PHONY: all setup build up down logs ps clean restart
