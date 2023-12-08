#!/bin/bash
#Starts biapi
git submodule update --init --recursive
docker-compose -f docker-compose.yml -f docker-compose-redis.yml -f docker-compose-gigwa.yml -f docker-compose-dev.yml build biapi
docker-compose -f docker-compose.yml -f docker-compose-redis.yml -f docker-compose-gigwa.yml -f docker-compose-dev.yml up -d
wait