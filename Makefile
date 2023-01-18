name = inception

all: up

up: create-dir
	docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d

create-dir:
ifeq ("$(wildcard ~/data)","")
	mkdir ~/data
	mkdir ~/data/wordpress
	mkdir ~/data/mariadb
else
	@echo directories exists
endif

build:
	docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build

down:
	docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env down

re: down
	docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build

clean: down
	@docker system prune -a
	@sudo rm -rf ~/data/wordpress/*
	@sudo rm -rf ~/data/mariadb/*
	@sudo rm -rf ~/data

fclean:
	docker stop $$(docker ps -qa)
	docker system prune --all --force --volumes
	docker network prune --force
	docker volume prune --force
	docker volume rm $$(docker volume ls -q)
	sudo rm -rf ~/data/wordpress/*
	sudo rm -rf ~/data/mariadb/*

nginx:
	docker build -t n_ginx --build-arg DOMAIN_NAME=mnathali.42.fr \
	srcs/requirements/nginx/

mariadb:
	docker build -t m_ariadb --build-arg DB_NAME=wordpress \
	--build-arg DB_USER=wpuser --build-arg DB_PASS=1234 \
	srcs/requirements/mariadb/

wordpress:
	docker build -t w_ordpress --build-arg DB_NAME=wordpress \
	--build-arg DB_USER=wpuser --build-arg DB_PASS=1234 \
	--build-arg DOMAIN_NAME=mnathali.42.fr \
	--build-arg WP_ADMIN=mnathali --build-arg WP_PASS=1234 \
	--build-arg WB_EMAIL=wpuser --build-arg TITLE=Mnathali \
	srcs/requirements/wordpress/

volume:
	docker volume create --opt o=bind --opt type=none --opt device=/home/$(USER)/data/mariadb/db-volume
	docker volume create --opt o=bind --opt type=none --opt device=/home/$(USER)/data/wordpress/wp-volume

network:
	docker network create inception

run:
	docker run -d --network inception -v db-volume:/var/lib/mysql --name mariadb m_ariadb
	docker run -d --network inception -v wp-volume:/var/www/wordpress --name wordpress w_ordpress
	docker run -d --network inception -p 443:443 -v wp-vulume:/var/www/wordpress --name nginx n_ginx

.PHONY	: all build down re clean fclean
