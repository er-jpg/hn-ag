FROM elixir:1.13-slim as releaser

WORKDIR /app

# Install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

COPY config/ /app/config/
COPY mix.exs /app/
COPY mix.* /app/

COPY apps/http_service/mix.exs /app/apps/http_service/
COPY apps/data_service/mix.exs /app/apps/data_service/
COPY apps/hn_service/mix.exs /app/apps/hn_service/

ENV MIX_ENV=prod
RUN mix do deps.get --only $MIX_ENV, deps.compile

COPY . /app/


# WORKDIR /app/apps/http_service
# RUN MIX_ENV=prod mix compile
# RUN npm install --prefix ./assets
# RUN npm run deploy --prefix ./assets
# RUN mix phx.digest

WORKDIR /app
RUN MIX_ENV=prod mix release --overwrite

########################################################################

FROM elixir:1.13-slim

EXPOSE 4000
ENV PORT=4000 \
    MIX_ENV=prod \
    SHELL=/bin/bash

WORKDIR /app
COPY --from=releaser app/_build/prod/rel/hn_ag .
COPY --from=releaser app/bin/ ./bin

CMD ["./bin/start.sh"]