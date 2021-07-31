FROM elixir:1.12

EXPOSE 4000

WORKDIR /app

COPY mix.exs mix.lock /

RUN mix do local.hex --force, local.rebar --force

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install inotify-tools

CMD mix phx.server

