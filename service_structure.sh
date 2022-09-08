#!/usr/bin/env bash
repo_name=${PWD##*/}
ports=$2

version="0.1.0"
maintener="Jvlio Ouverney"
use_message="
  $(basename $0) - [MENU]

  -------------------------------------------------------
  | INFOS:                                              |
  |    --help : Help Menu                               |
  |    --about : Version && Maintener                   |
  -------------------------------------------------------
  | USAGE (--back/--front):                             |
  |    ./service_structure.sh --frontend 8080           |
  -------------------------------------------------------
  | FUNCTIONS:                                          |
  |    --back : Don't install npm (to run VueJs)        |
  |    --front : Install npm (to run VueJs)             |
  -------------------------------------------------------
"


## Creating structures of directories and files
prepareTo(){
mkdir -p ~/$repo_name/docker-compose/envs ~/$repo_name/docker-compose/manifests ~/$repo_name/docker-compose/composer_files
touch ~/$repo_name/docker-compose/.env ~/$repo_name/docker-compose/docker-compose.yml ~/$repo_name/docker-compose/manifests/dev.Dockerfile ~/$repo_name/docker-compose/.auth.json

echo 'DOCKERFILE=./manifests/dev.Dockerfile
PORT= '$ports'
ROOT_DIR=..
REPO_DIR=../.. '> docker-compose/.env

echo 'FROM enterprise_repo/image:0.0.0' > ~/$repo_name/docker-compose/manifests/dev.Dockerfile  
}

## copiar laravel  > laravel_tmp
copyLaravel(){
docker exec -it $repo_name sudo cp -Rp ./* ../laravel_tmp
docker exec -it $repo_name sudo cp -Rp ./.* ../laravel_tmp
}

## cria o docker-compose
dcCreate(){
echo 'version: "3.3"
services:
  '${repo_name}':
    build:
      context: ./
      dockerfile:  ${DOCKERFILE}
    ports:
      - ${PORT}:8080
    volumes:
      - ${ROOT_DIR}/laravel:/var/www/html/'$1'
      - ${REPO_DIR}/proprietary_pckg:/home/bitnami/proprietary_pckg
      - ${REPO_DIR}/proprietary_pckg:/home/bitnami/proprietary_pckg
    container_name: '${repo_name}'
    hostname: '${repo_name}'
    # command: bash -c  "composer update" 
    # command: bash -c  "composer install" 
    networks:
      - default_network

networks:
  default_network:
    external: 
      name: default_network ' > ~/$repo_name/docker-compose/docker-compose.yml
}


## criando log file do supervisor e dando permissão
supervisor(){
sudo touch ~/$repo_name/laravel/storage/logs/supervisor/queue-worker-out.log
sudo chmod -R 777 ~/$repo_name/laravel/vendor ~/$repo_name/laravel/storage ~/$repo_name/laravel/bootstrap ~/$repo_name/laravel/config  
}

run(){

sudo ls

echo -e "Creating directories and files \n"
prepareTo
  sleep 1
dcCreate laravel_tmp

echo -e "\nRunning container \n"
cd ~/$repo_name/docker-compose && docker-compose up -d
  sleep 2

if [[ "$1" = "frontend" ]]; then
echo -e "\nInstalling npm \n"
docker exec -it $repo_name npm install
fi

echo -e "\nCopying laravel/ \n"
copyLaravel
  sleep 1

echo -e "\nReplacing docker-compose.yml \n"
dcCreate laravel

echo -e "\nRunning container with force \n"
cd ~/$repo_name/docker-compose && docker-compose up --build --force-recreate -d

echo -e "\nCreating log file supervisor \n"
supervisor

rm -rf ~/$repo_name/laravel/laravel_tmp
}

## Execution

case "$1" in
    '') echo "Arguments missing, see --help." && exit 1   ;;
    --help) echo "$use_message" && exit 0                 ;;
    --back) run backend                                   ;;
    --front) run frontend                                 ;;
    --about) echo "$version - $maintener" && exit 0       ;;
    *) echo "Unexistent option, see --help" && exit 1     ;;
esac