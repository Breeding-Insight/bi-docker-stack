# Prereqs
Docker and Docker-compose are both required.

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
of the repo locally create a file called `.env` (a template exists named `.env.template`) 
and save the Lastpass contents for "bi-api secrets" in this file.

# Run

## Production Environment

An instance of Redis and Gigwa are expected to be running.  The `.env` file must be updated to reflect where these services live.  To stand up instances of Redis or Gigwa, please refer to their respective docker-compose files (`docker-compose-redis.yml`, `docker-compose-gigwa.yml`)

```
docker-compose up -d
```

## Pre-Production Environment
```
docker-compose -f docker-compose.yml -f docker-compose-redis.yml -f docker-compose-gigwa.yml -f docker-compose-qa.yml -f docker-compose-rc.yml up -d
```

## QA Environment
```
docker-compose -f docker-compose.yml -f docker-compose-redis.yml -f docker-compose-gigwa.yml -f docker-compose-qa.yml up -d
```

## AWS S3 Configuration
If running in production, then you will need to create an AWS IAM role to generate an access key and secret.  You will also need to define a bucket in S3 to hold the data.

If you do not want to use AWS, you can utilize the localstack configuration by including `-f docker-compose-localstack.yml` in your `docker-compose up` command.

Then values for the AWS parameters can be set as follows:

```
AWS_ACCESS_KEY_ID=test
AWS_SECRET_KEY=test
AWS_S3_ENDPOINT=http://localhost:4566
```

## TLS Support
In a deployment environment TLS support can be easily provided by the reverse
proxy container which already has Certbot by LetsEncrypt installed. The
deployment environment should set the value of the environment variable
`REGISTERED_DOMAIN` to the value of the registered domain for deployed instance.  
NOTE* This environment variable should be added to your `.env` file

Bash into the docker container named `biproxy` and call Certbot.

```
docker exec -it biproxy bash
certbot --nginx -d <REGISTERED_DOMAIN>
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


# Development Environment

To run a development environment, you will need to initialize the git submodules that exist within this repository:

```
git submodule update --init --recursive
```

Then run:

```
docker-compose -f docker-compose.yml -f docker-compose-redis.yml -f docker-compose-gigwa.yml -f docker-compose-dev.yml up -d
```
