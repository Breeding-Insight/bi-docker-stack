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

# Configuration
The containers are not run by the root user but by a new user and group called 'host'.  The user and group ids for host are both
set to 1001 by default.  If you wish to change these to your own user and group ids, create a .env file with the following contents:
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

## Production Environment
```
docker-compose up -d
```

## Development Environment
```
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```