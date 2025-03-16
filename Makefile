DC	=	cd srcs && docker compose


.PHONY: build up down logs ps restart

all: build up

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

restart: down up