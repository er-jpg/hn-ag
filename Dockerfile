ARG BUILDER_IMAGE="hexpm/elixir:1.13.1-erlang-24.2-debian-bullseye-20210902-slim"
ARG RUNNER_IMAGE="debian:bullseye-20210902-slim"

FROM ${BUILDER_IMAGE} as builder

RUN apt-get update -y && apt-get install -y build-essential git npm \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

WORKDIR /app

RUN mix local.hex --force && \
  mix local.rebar --force

ENV MIX_ENV="prod"

COPY mix.exs mix.lock ./
COPY apps/http_service/mix.exs ./apps/http_service/mix.exs
COPY apps/ets_service/mix.exs ./apps/ets_service/mix.exs

RUN mix deps.get --only $MIX_ENV
RUN mkdir config

COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

COPY apps/http_service/priv apps/http_service/priv

COPY apps/http_service/assets apps/http_service/assets
RUN cd apps/http_service && mix assets.deploy

COPY apps apps

RUN mix compile

COPY config/runtime.exs config/

RUN mix release

FROM ${RUNNER_IMAGE}

RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

COPY --from=builder --chown=nobody:root /app/_build/prod/rel/hn_ag ./

USER nobody

ENTRYPOINT [ "/app/bin/hn_ag" ]