all: build up

build:
	docker-compose -f srcs/docker-compose.yml build

up:
	docker-compose -f srcs/docker-compose.yml up -d

down:
	docker-compose -f srcs/docker-compose.yml down

clean:
	docker-compose -f srcs/docker-compose.yml down --volumes
	docker system prune -f
	rm -rf srcs/data
