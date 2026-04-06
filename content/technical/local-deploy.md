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

## 1. Clone the repositories

Black Mesa is split across four repositories. Clone them all into one working
directory - the Dockerfiles and Compose file expect them as siblings.

```bash
mkdir blackmesadev && cd blackmesadev && \
git clone https://github.com/blackmesadev/black-mesa.git && \
git clone https://github.com/blackmesadev/lib.git && \
git clone https://github.com/blackmesadev/api.git && \
git clone https://github.com/blackmesadev/mesastream.git && \
git clone https://github.com/blackmesadev/dashboard.git
```

After cloning, your directory should look like:

```
blackmesadev/
├-- api/
├-- black-mesa/
├-- dashboard/
├-- lib/
└-- mesastream/

```

## 2. Switch to local library paths

By default, for production, `black-mesa`, `api`, and `mesastream` reference `bm-lib` from GitHub. For a local
build where `lib/` is already on disk, switch to the path dependency so the
compiler uses the copy you just cloned.

In `black-mesa/Cargo.toml`, swap the two `bm-lib` lines:

**black-mesa/Cargo.toml**

```toml
# Comment out the git source:
# bm-lib = { git = "https://github.com/blackmesadev/lib.git" }

# Uncomment the local path:
bm-lib = { path = "../lib" }
```

Do the same in `api/Cargo.toml`:

**api/Cargo.toml**

```toml
# bm-lib = { git = "https://github.com/blackmesadev/lib.git" }
bm-lib = { path = "../lib" }
```

And in `mesastream/Cargo.toml`:

**mesastream/Cargo.toml**

```toml
# bm-lib = { git = "https://github.com/blackmesadev/lib.git" }
bm-lib = { path = "../lib" }
```

Next, update each Dockerfile so the local `lib/` directory is copied into the build context.
All three currently have this line commented out as `# COPY ./lib /app/lib`.

Uncomment it in:

- `black-mesa/Dockerfile`
- `api/Dockerfile`
- `mesastream/Dockerfile`

So it becomes:

```dockerfile
COPY ./lib /app/lib
```

> **Why?** The Dockerfiles already copy `./lib` into the build context with
> `COPY ./lib /app/lib`. With the `path` dependency active, Cargo uses that
> local copy rather than reaching out to GitHub - faster builds and you can
> iterate on library changes without pushing first.

## 3. Create docker-compose.yml

Create `docker-compose.yml` in the root `blackmesa/` directory. The example
below mirrors the production layout with placeholder credentials - replace every
occurrence of `changeme` with strong random values before running.

**blackmesa/docker-compose.yml**

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

The Compose file includes **OpenObserve** for collecting traces, logs, and metrics
from all services. The Black Mesa services are instrumented with OpenTelemetry and
will automatically export telemetry if configured.

A key note for contributing, any function that does a major piece of logic, or is essential for flow should be instrumented but never include private/sensitive data, exceptions are made for `guild_id` and `user_id` as they are essential for support.

## 4. Configure environment files

Each service reads a `.env` file in its own directory. The easiest setup is to
copy the provided examples first:

```bash
cp black-mesa/.env.example black-mesa/.env
cp api/.env.example api/.env
cp mesastream/.env.example mesastream/.env
```

Then edit each `.env` and replace placeholder values (`changeme`,
`replace_with_secure_password`, etc.) with real values for your machine.

Quick setup with sed (replace the example values with your actual credentials):

```bash
# Set your actual credentials
DISCORD_TOKEN="your_bot_token_here"
DISCORD_CLIENT_ID="your_client_id_here"
DISCORD_CLIENT_SECRET="your_client_secret_here"
DB_PASSWORD="your_secure_db_password"
REDIS_PASSWORD="your_secure_redis_password"
JWT_SECRET="your_random_jwt_secret_minimum_32_chars"

# Update black-mesa/.env
sed -i "s|DISCORD_TOKEN=.*|DISCORD_TOKEN=\"${DISCORD_TOKEN}\"|" black-mesa/.env
sed -i "s|postgres://mesa:[^@]*@|postgres://mesa:${DB_PASSWORD}@|" black-mesa/.env
sed -i "s|redis://:[^@]*@|redis://:${REDIS_PASSWORD}@|" black-mesa/.env

# Update api/.env
sed -i "s|DISCORD_BOT_TOKEN=.*|DISCORD_BOT_TOKEN=\"${DISCORD_TOKEN}\"|" api/.env
sed -i "s|DISCORD_CLIENT_ID=.*|DISCORD_CLIENT_ID=\"${DISCORD_CLIENT_ID}\"|" api/.env
sed -i "s|DISCORD_CLIENT_SECRET=.*|DISCORD_CLIENT_SECRET=\"${DISCORD_CLIENT_SECRET}\"|" api/.env
sed -i "s|JWT_SECRET=.*|JWT_SECRET=\"${JWT_SECRET}\"|" api/.env
sed -i "s|postgres://mesa:[^@]*@|postgres://mesa:${DB_PASSWORD}@|" api/.env
sed -i "s|redis://:[^@]*@|redis://:${REDIS_PASSWORD}@|" api/.env

# Update mesastream/.env
sed -i "s|redis://:[^@]*@|redis://:${REDIS_PASSWORD}@|" mesastream/.env
```

### Get Discord credentials from the Developer Dashboard

Open the Discord Developer Portal: <https://discord.com/developers/applications>

1. Create/select your application.
2. In **OAuth2 -> General**, copy:
  - **Client ID** -> use as `DISCORD_CLIENT_ID`
  - **Client Secret** -> use as `DISCORD_CLIENT_SECRET`
3. In **Bot**, create/reset and copy the **Bot Token**:
  - use as `DISCORD_BOT_TOKEN` in `api/.env`
  - use as `DISCORD_TOKEN` in `black-mesa/.env`

Keep these values private. If a token leaks, regenerate it in the portal.

`DATABASE_URL` should match the Postgres credentials in your Compose file, e.g.
`postgres://mesa:changeme@localhost:5432/blackmesa`. `REDIS_URI` should include
the password you set, e.g. `redis://:changeme@localhost:6379`.

### Bake OTLP auth token from OpenObserve credentials

OpenObserve OTLP expects an `Authorization` header. In this stack, pass it via
`OTLP_AUTH` as a Basic token built from the same username/password you configured
for OpenObserve (`ZO_ROOT_USER_EMAIL` and `ZO_ROOT_USER_PASSWORD` in Compose).

```bash
# Replace with the values from docker-compose.yml
OO_USER="admin@example.com"
OO_PASS="changeme"

# Linux: -w0 disables line wrapping
OTLP_AUTH="Basic $(printf '%s' "${OO_USER}:${OO_PASS}" | base64 -w0)"
```

Apply the token to all service `.env` files:

```bash
for f in black-mesa/.env api/.env mesastream/.env; do
  if grep -q '^OTLP_AUTH=' "$f"; then
    sed -i "s|^OTLP_AUTH=.*|OTLP_AUTH=\"${OTLP_AUTH}\"|" "$f"
  else
    printf '\nOTLP_AUTH="%s"\nOTLP_ORGANIZATION=default\n' "$OTLP_AUTH" >> "$f"
  fi
done
```

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
from the running services (if you configured `OTLP_ENDPOINT`).

## 7. Dashboard setup (local OAuth flow)

Copy the dashboard env example, then configure with sed:

```bash
cp dashboard/.env.example dashboard/.env

# Use the same client ID from earlier
sed -i "s|VITE_DISCORD_CLIENT_ID=.*|VITE_DISCORD_CLIENT_ID=${DISCORD_CLIENT_ID}|" dashboard/.env
sed -i "s|VITE_API_BASE_URL=.*|VITE_API_BASE_URL=http://localhost:8080/api|" dashboard/.env

# For root path deployment (default):
sed -i "s|VITE_DISCORD_REDIRECT_URI=.*|VITE_DISCORD_REDIRECT_URI=http://localhost:4173/oauth/discord|" dashboard/.env

# OR for /dashboard/ subpath deployment:
# sed -i "s|VITE_DISCORD_REDIRECT_URI=.*|VITE_DISCORD_REDIRECT_URI=http://localhost:4173/dashboard/oauth/discord|" dashboard/.env
# sed -i "s|VITE_BASE_PATH=.*|VITE_BASE_PATH=/dashboard/|" dashboard/.env
```

Make sure your API env uses the same callback URL:

```bash
# Set redirect URI in api/.env (use the same path as dashboard)
sed -i "s|DISCORD_REDIRECT_URI=.*|DISCORD_REDIRECT_URI=http://localhost:4173/oauth/discord|" api/.env

# Or if using /dashboard/ subpath:
# sed -i "s|DISCORD_REDIRECT_URI=.*|DISCORD_REDIRECT_URI=http://localhost:4173/dashboard/oauth/discord|" api/.env
```

In Discord Developer Portal -> **OAuth2 -> Redirects**, add:

- `http://localhost:4173/oauth/discord`
- `http://localhost:4173/dashboard/oauth/discord` (only if using `VITE_BASE_PATH=/dashboard/`)

Then start the dashboard: (functionality is Nothing until you have the API running and properly connected to Discord)

```bash
cd dashboard
pnpm i
pnpm run dev
```

Open `http://localhost:4173` and test **Login with Discord**.

## Stopping and cleanup

```bash
# Stop all services, preserve data volumes
docker compose down

# Stop and remove volumes - resets the database and Redis
docker compose down -v
```
