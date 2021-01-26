# ApiBanking

[![Build Status](https://github.com/cardoso010/api_banking/workflows/TEST/badge.svg?branch=main)](https://github.com/cardoso010/api_banking/actions)
[![Build Status](https://github.com/cardoso010/api_banking/workflows/DEPLOY/badge.svg?branch=main)](https://github.com/cardoso010/api_banking/actions)

## Requirements

Resources that must be installed for this project to work.

- [docker](https://docs.docker.com/install/)
- [docker-compose](https://docs.docker.com/compose/install/)

## Setup

Clone this repository:

```shell
git clone https://github.com/cardoso010/api_banking.git
```

```shell
cd api_banking
```

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

Now you can visit [`localhost:4000/api/v1`](http://localhost:4000/api/v1) from your browser

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

You can visit Swagger [`localhost:4000/api/swagger/index.html`](http://http://localhost:4000/api/swagger/index.html) from your browser.

## Deployment

Project is running at Heroku Platform, so you can access [`https://apibanking.herokuapp.com/api/v1`](https://apibanking.herokuapp.com/api/v1).

Or you can access swagger directly [`https://apibanking.herokuapp.com/api/swagger/index.html`](https://apibanking.herokuapp.com/api/swagger/index.html) from your browser
