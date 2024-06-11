name = inception

#-f flag to specify a path to a Compose file that is not located in the current director
#--env-file srcs/.env: This tells Docker Compose to read environment variables from the .env file located in the srcs directory. Environment variables defined in this file will be available to your services.
#the .env file allows you to store sensitive information outside your configuration file, making it easier to manage and keep secret.
#up command tells Docker Compose to start the services defined in your configuration file.
#the -d flag stands for "detached mode". When you use this flag with docker-compose up, it instructs Docker Compose to start the containers in the background and detach from them. This means that your terminal session won't be associated with the running containers, and you can continue using your terminal for other tasks.meaning they will run in the background and you won't be connected to their console.
#The "--build" flag tells Docker Compose to build any images that are not yet built or have changed since the last build.
all:
	@mkdir -p ~/data/db-volume
	@mkdir -p ~/data/wp-volume
	@printf "\033[34m starting services \033[0m\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build

build:
	@printf "\033[34m building services \033[0m\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env build

up:
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d

down:
	@printf "\033[34m Stopping configuration ${name}...\033[0m\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env down
start:
	@printf "\033[34m restarting one or more existing stopped containers \033[0m\n"
	@docker compose -f ./srcs/docker-compose.yml start

stop:
	@printf "\033[34m Stopping one or more running containers \033[0m\n"
	@docker compose -f ./srcs/docker-compose.yml stop

logs:
	@docker-compose -f ./srcs/docker-compose.yml logs

re: down up
	@printf "Rebuild configuration ${name}...\n"

#The docker prune command helps you clean up unused Docker objects to reclaim disk space.
#-a (or -all) removes volumes, networks, images and containers as below
#Volumes: Removes all unused anonymous and named volumes.
#Networks: Removes all unused networks.
#Images: Removes all unused images, not just dangling ones.
#Containers: Removes all stopped containers, even those without --rm flag.
#-f (or -force) Bypasses the confirmation prompt before deleting objects.
#-v is for removing volumes. Do we want to remove volumes in clean?
clean:
	@docker-compose -f ./srcs/docker-compose.yml down -v
	@printf "\033[33m cleaning configurations ${name} \033[0m\n"
	@docker system prune -af

#rm -rf  This stands for "remove recursively with force" and permanently deletes all files and directories within the specified paths, including subdirectories and their contents.
#Deleting ~/data/mariadb ~/data/wordpress without a backup would result in permanent data loss and potentially break your applications.
fclean: clean
	@printf "\033[31m WARNING: total cleaning, including volumes \033[0m\n"
	@sudo rm -rf ${HOME}/data/mariadb/*
	@sudo rm -rf ${HOME}/data/wordpress/*
	@sudo rm -rf ${HOME}/data

.PHONY: all up down restart clean fclean start stop build re

