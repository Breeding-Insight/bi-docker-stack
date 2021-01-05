# Installation
Docker and  Docker-compose are both required.

Cloning this repo wil create empty folders for two git submodules: bi-api and
bi-web.  The source code for these submodules must be pulled by first updating
the local .git/config with the mapping from the .gitmodules file in this repo 
and fetching the data as well. 
```
git submodule update --init --recursive
```

The docker-compose.yml should contain a service for each environment the API is
to be run in: e.g develop, test, staging, and production.  Each service contains
under the environment key public values for environment variables used as params
for the API configuration.

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

## Configure Services

Private values used in each environment are stored in Lastpass and are never
placed in docker-compose.yml and never committed to the repo.  At the root level
of the repo locally create a file called .env and save the Lastpass contents for
"bi-api secrets" in this file.

# Run

## Production Environment
```
docker-compose up -d
```

## Development Environment
```
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```
## TLS Support
In a deployment environment TLS support can be easily provided by the reverse
proxy container which already has Certbot by LetsEncrypt installed. The
deployment environment should set the value of the environment variable
`REGISTERED_DOMAIN` to the value of the registered domain for deployed instance.

Bash into the docker container named `biproxy` and call Certbot.
```
docker exec -it biproxy bash
certbot -d --nginx <REGISTERED_DOMAIN>
```
Certbot will ask a series of questions to be answered interactively, then 
automatically install the TLS certs and update the nginx config files.

## Reverse Proxy
The nginx config files and TLS certs are stored on volumes mounted on the host
machine, ensuring that TLS will continue to be used even after restarting the
docker stack after code updates. However, this also means that a volume must be
removed before restarting the stack if there are updates to the configuration of
the reverse proxy.

The Dockerfile for the reverse proxy contains the nginx rules used to direct
traffic to the appropriate upstream server. Any new features added to bi-api
that use an endpoint not in the /v1/ or /sso/ name spaces must have a rule added
to the proxy config in order to send these requests upstream.
