+++
title = "Local Deployment"
weight = 1
+++

This guide walks through cloning all Black Mesa components and running the full
stack locally with Docker Compose.

## Prerequisites

- **Docker 24+** with the Compose plugin - verify with `docker compose version`
- **Git**
- A **Discord application** with a bot token ([create one here](https://discord.com/developers/applications))
- ~3 GB of free RAM for the combined containers (including observability stack)

## 1. Clone the repositories

Black Mesa is split across four repositories. Clone them all into one working
directory - the Dockerfiles and Compose file expect them as siblings.

```bash
mkdir blackmesa && cd blackmesa
git clone https://github.com/blackmesadev/black-mesa.git
git clone https://github.com/blackmesadev/lib.git
git clone https://github.com/blackmesadev/api.git
git clone https://github.com/blackmesadev/mesastream.git
```

After cloning, your directory should look like:

```
blackmesa/
├── api/
├── black-mesa/
├── lib/
└── mesastream/
```

## 2. Switch to local library paths

By default, for production, `black-mesa` and `api` reference `bm-lib` from GitHub. For a local
build where `lib/` is already on disk, switch to the path dependency so the
compiler uses the copy you just cloned.

In `black-mesa/Cargo.toml`, swap the two `bm-lib` lines:

{% codeblock(title="black-mesa/Cargo.toml") %}
```toml
# Comment out the git source:
# bm-lib = { git = "https://github.com/blackmesadev/lib.git" }

# Uncomment the local path:
bm-lib = { path = "../lib" }
```
{% end %}

Do the same in `api/Cargo.toml`:

{% codeblock(title="api/Cargo.toml") %}
```toml
# bm-lib = { git = "https://github.com/blackmesadev/lib.git" }
bm-lib = { path = "../lib" }
```
{% end %}

> **Why?** The Dockerfiles already copy `./lib` into the build context with
> `COPY ./lib /app/lib`. With the `path` dependency active, Cargo uses that
> local copy rather than reaching out to GitHub - faster builds and you can
> iterate on library changes without pushing first.

## 3. Create docker-compose.yml

Create `docker-compose.yml` in the root `blackmesa/` directory. The example
below mirrors the production layout with placeholder credentials - replace every
occurrence of `changeme` with strong random values before running.

{% codeblock(title="blackmesa/docker-compose.yml") %}
```yaml
services:
  black-mesa:
    build:
      context: .
      dockerfile: ./black-mesa/Dockerfile
    container_name: black-mesa
    depends_on:
      - postgres
      - redis
      - mesastream
    env_file:
      - black-mesa/.env
    volumes:
      - ./lib:/app/lib:ro
      - ./black-mesa/src:/app/black-mesa/src:ro

  mesa-api:
    build:
      context: .
      dockerfile: ./api/Dockerfile
    container_name: mesa-api
    ports:
      - "127.0.0.1:8080:8080"
    depends_on:
      - postgres
      - redis
    env_file:
      - api/.env

  mesastream:
    build:
      context: .
      dockerfile: ./mesastream/Dockerfile
    container_name: mesastream
    depends_on:
      - redis
    ports:
      - "127.0.0.1:8070:8070"
    env_file:
      - mesastream/.env
    volumes:
      - ./lib:/app/lib:ro
      - ./mesastream/src:/app/mesastream/src:ro
      - ./data/mesastream:/var/cache/mesastream/audio

  postgres:
    image: postgres:17
    container_name: postgres
    restart: unless-stopped
    volumes:
      - ./data/postgres:/var/lib/postgresql/data
    ports:
      - "127.0.0.1:5432:5432"
    environment:
      POSTGRES_USER: mesa
      POSTGRES_PASSWORD: changeme
      POSTGRES_DB: blackmesa

  redis:
    image: redis:latest
    container_name: redis
    volumes:
      - ./data/redis:/data
    ports:
      - "127.0.0.1:6379:6379"
    command: redis-server --requirepass changeme

  openobserve:
    image: public.ecr.aws/zinclabs/openobserve:latest
    container_name: openobserve
    restart: unless-stopped
    volumes:
      - ./data/openobserve:/data
    ports:
      - "127.0.0.1:5080:5080"
    environment:
      ZO_ROOT_USER_EMAIL: admin@example.com
      ZO_ROOT_USER_PASSWORD: changeme
      ZO_DATA_DIR: /data

networks:
  default:
    name: blackmesa-network
    external: true
```
{% end %}

The Compose file includes **OpenObserve** for collecting traces, logs, and metrics
from all services. The Black Mesa services are instrumented with OpenTelemetry and
will automatically export telemetry if configured.

A key note for contributing, any function that does a major piece of logic, or is essential for flow should be instrumented but never include private/sensitive data, exceptions are made for `guild_id` and `user_id` as they are essential for support.

## 4. Configure environment files

Each service reads a `.env` file in its own directory. Create them before
starting. The key variables each service expects:

| File | Key variables |
| --- | --- |
| `black-mesa/.env` | `DISCORD_TOKEN`, `DATABASE_URL`, `REDIS_URL`, `OTEL_EXPORTER_OTLP_ENDPOINT` |
| `api/.env` | `DATABASE_URL`, `REDIS_URL`, `JWT_SECRET`, `DISCORD_CLIENT_ID`, `DISCORD_CLIENT_SECRET`, `OTEL_EXPORTER_OTLP_ENDPOINT` |
| `mesastream/.env` | `REDIS_URL`, `OTEL_EXPORTER_OTLP_ENDPOINT` |

`DATABASE_URL` should match the Postgres credentials in your Compose file, e.g.
`postgres://mesa:changeme@localhost:5432/blackmesa`. `REDIS_URL` should include
the password you set, e.g. `redis://:changeme@localhost:6379`.

**Optional telemetry:** To send traces and logs to OpenObserve, set
`OTEL_EXPORTER_OTLP_ENDPOINT=http://openobserve:5080/api/default/` in each
service's `.env` file. This enables distributed tracing across the entire stack.

See each repository's `README.md` for the complete variable reference.

## 5. Create the Docker network

The Compose file uses an external named network. Create it once before the first `up`:

```bash
docker network create blackmesa-network
```

## 6. Build and start

```bash
docker compose up -d --build
```

The first build pulls the Rust toolchain image and compiles release binaries -
expect several minutes. Subsequent builds hit Docker layer and Cargo registry
caches and are much faster.

Verify everything came up cleanly:

```bash
docker compose logs -f black-mesa mesa-api mesastream
```

- **API:** `http://localhost:8080`
- **Mesastream:** `http://localhost:8070`
- **OpenObserve UI:** `http://localhost:5080` (login with the credentials from your Compose file)

Once logged into OpenObserve, navigate to **Traces** or **Logs** to view telemetry
from the running services (if you configured `OTEL_EXPORTER_OTLP_ENDPOINT`).

## Stopping and cleanup

```bash
# Stop all services, preserve data volumes
docker compose down

# Stop and remove volumes - resets the database and Redis
docker compose down -v
```
