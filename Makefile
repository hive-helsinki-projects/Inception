DC					=	cd srcs && docker compose
DOMAIN				=	${USER}.42.fr


all:	setup build up

setup:
	@echo "Creating data directories.."
	@mkdir -p ~/data/mariadb && chmod 777 ~/data/mariadb
	@mkdir -p ~/data/wordpress && chmod 777 ~/data/wordpress
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
	@echo "Removing domain from hosts file"
	@sed -i '/$(DOMAIN)/d' /etc/hosts

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