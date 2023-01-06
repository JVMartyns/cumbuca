FROM hexpm/elixir:1.14.0-erlang-25.0-alpine-3.17.0

WORKDIR /app

RUN apk update && apk add --no-cache build-base

RUN mix local.hex --force && \
    mix local.rebar --force

COPY . .

RUN mix do deps.get, deps.compile

EXPOSE 4000

CMD [ "mix", "phx.server" ]