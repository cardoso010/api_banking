FROM hexpm/elixir:1.11.1-erlang-23.1.1-alpine-3.12.0

ARG MIX_ENV=dev

RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
    make \
    gcc \
    libc-dev \
    bash \
    build-base && \
    mix local.rebar --force && \
    mix local.hex --force && \
    mix archive.install --force hex phx_new 1.5.7 


ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
COPY . $APP_HOME

EXPOSE 4000

CMD mix phx.server