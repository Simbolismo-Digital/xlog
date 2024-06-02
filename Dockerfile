FROM elixir:1.14.2-alpine

ENV MIX_ENV=prod
ENV DATABASE_URL=build_placeholder
ENV SECRET_KEY_BASE=build_placeholder

RUN apk --no-cache --update add \
  postgresql-client \
  bash \
  alpine-sdk \
  coreutils \
  curl \
  nodejs \
  npm \
  && rm -rf /var/cache/apk/*

RUN mix local.hex --force \
  && mix local.rebar --force

COPY . /app
WORKDIR /app

RUN mix deps.get --only prod \
  && mix do compile

# Compile assets
RUN mix assets.setup && mix phx.digest

EXPOSE 4000

CMD mix ecto.setup && mix phx.server