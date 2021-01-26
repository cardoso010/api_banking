# ApiBanking

[![Build Status](https://github.com/cardoso010/api_banking/workflows/TEST/badge.svg?branch=main)](https://github.com/cardoso010/api_banking/actions)
[![Build Status](https://github.com/cardoso010/api_banking/workflows/DEPLOY/badge.svg?branch=main)](https://github.com/cardoso010/api_banking/actions)

## Requirements

Resources that must be installed for this project to work.

- [docker](https://docs.docker.com/install/)
- [docker-compose](https://docs.docker.com/compose/install/)

## Setup

This project uses docker-compose.

First of all you need to build the container

```shell
docker-compose build
```

Now is necessary that you run setup to get dependencies, create database, create migrations and run seed.

```shell
docker-compose run web mix setup
```

Then you up your container

```shell
docker-compose up
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser
or you can visit [`apibanking.herokuapp.com`](https://apibanking.herokuapp.com/) as well.

Exec tests

```shell
docker-compose run -e "MIX_ENV=test" web mix test
```

Exec coveralls

```shell
docker-compose run -e "MIX_ENV=test" web mix coveralls
```

Generate Swagger Docs

```shell
docker-compose run web mix phx.swagger.generate
```

You can visit Swagger [`localhost:4000/api/swagger/index.html`](http://http://localhost:4000/api/swagger/index.html) from your browser
