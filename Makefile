DC					=	cd srcs && docker compose
VOLUME_PATH			=	/home/${USER}/data
WORDPRESS_VOLUME	=	$(VOLUME_PATH)/wordpress
MARIADB_VOLUME		=	$(VOLUME_PATH)/mariadb
DOMAIN				=	${USER}.42.fr

all: setup build up

setup:
	@echo "Creating data directories.."
	@mkdir -p $(WORDPRESS_VOLUME)
	@mkdir -p $(MARIADB_VOLUME)
# @chmod 777 $(WORDPRESS_VOLUME)
# @chmod 777 $(MARIADB_VOLUME)
	@if ! grep -q "$(DOMAIN)" /etc/hosts; then \
	echo "127.0.0.1 $(DOMAIN)" | tee -a /etc/hosts; \
	fi

build:
	@$(DC) build

up:
	@$(DC) up -d

down:
	@$(DC) down

logs:
	@$(DC) logs -f

ps:
	@$(DC) ps

clean:
	@echo "Removing data directories.."
	@rm -rf $(WORDPRESS_VOLUME)
	@rm -rf $(MARIADB_VOLUME)
	docker stop $(shell docker ps -a -q)
	docker rm $(shell docker ps -a -q)
	docker rmi $(shell docker images -q)
	docker volume rm $(shell docker volume ls -q)
	docker network rm $(shell docker network ls -q) 2>/dev/null

restart: clean down up

.PHONY: build up down logs ps restart setup clean
