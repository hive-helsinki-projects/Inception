DC			=	cd srcs && docker compose
VOLUME_PATH		=	/Users/${USER}/data
WORDPRESS_VOLUME	=	$(VOLUME_PATH)/wordpress
MARIADB_VOLUME		=	$(VOLUME_PATH)/mariadb
DOMAIN			=	${USER}.42.fr

all:	setup build up

setup:
	@echo "Creating data directories.."
	@sudo mkdir -p $(WORDPRESS_VOLUME)
	@sudo mkdir -p $(MARIADB_VOLUME)
	@sudo chmod 777 $(WORDPRESS_VOLUME)
	@sudo chmod 777 $(MARIADB_VOLUME)
	@if ! grep -q "$(DOMAIN)" /etc/hosts; then \
		echo "127.0.0.1 $(DOMAIN)" | sudo tee -a /etc/hosts; \
	fi

build:
	@echo "Building docker images..."
	@$(DC) build --no-cache

up:
	@echo "Starting services..."
	@$(DC) up -d

down:
	@echo "Stopping services..."
	@$(DC) down

clean:	down
	@echo "Cleaning Docker resources"
	@docker system prune -af
	@echo "Removing docker volumes"
	@if [ "$$(docker volume ls -q)" ]; then \
		docker volume rm $$(docker volume ls -q); \
	fi

fclean: clean
	@echo "Removing data directories.."
	@sudo rm -rf $(VOLUME_PATH)
	@echo "Removing domain from hosts file"
	@sudo sed -i '/$(DOMAIN)/d' /etc/hosts

status:
	@echo "Container status:"
	@$(DC) ps
	@echo "Docker images:"
	@docker images
	@echo "Docker volumes:"
	@docker volume ls
	@echo "Docker networks:"
	@docker network ls

logs:
	@$(DC) logs -f

restart: down up

re:	fclean all

.PHONY: all setup build up down clean fclean status logs restart re help