#!/bin/bash
#Starts biapi
git submodule update --init --recursive
docker-compose -f docker-compose.yml -f docker-compose-redis.yml -f docker-compose-localstack.yml -f docker-compose-gigwa.yml -f docker-compose-dev.yml up -d --build biapi brapi-server mailhog bidb biproxy redis localstack gigwa mongo
wait
