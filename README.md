# Installation
Docker and  Docker-compose are both required.

Cloning this repo wil create empty folders for two git submodules: bi-api and
bi-web.  The source code for these submodules must be pulled by first updating
the local .git/config with the mapping from the .gitmodules file in this repo.
```
git submodule init
```
Then fetch all the data from the submodules.
```
git submodule update
```
The docker-compose.yml should contain a service for each environment the API is
to be run in: e.g develop, test, staging, and production.  Each service contains
under the environment key public values for environment variables used as params
for the API configuration.

Private values used in each environment are stored in Lastpass and are never
placed in docker-compose.yml and never committed to the repo.  At the root level
of the repo locally create a file called .env and save the Lastpass contents for
"bi-api secrets" in this file.

# Configuration
The containers are not run by the root user but by a new user and group called
'host'.  The user and group ids for host are both set to 1001 by default.  If
you wish to change these to your own user and group ids, add the following
contents to .env:
```
USER_ID=1001
GROUP_ID=1001
```
Change 1001 to your own id values.  You can find at the console your user and group ids using the id command:
for user id
```
id -u
```
and for group id
```
id -g
```

# Run
```
docker-compose up -d
```


## Docker support
The API can run inside a Docker container using the Dockerfile for building the
API image and the docker-compose.yml to run the container.
```
docker-compose up -d biapi-dev
```

