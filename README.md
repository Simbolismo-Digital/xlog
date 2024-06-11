# Xlog

## Setup

Github assumes your local git is configured.

## External Dependencies

- [Docker Compose](https://docs.docker.com/compose/)
  - [PostgreSQL](https://www.postgresql.org/) (mandatory in any environment)
- [asdf](https://asdf-vm.com/) (optional for running locally)
  - [Erlang](https://www.erlang.org/)
  - [Elixir](https://elixir-lang.org/)
  - [Node.js](https://nodejs.org/)
  - [Yarn](https://yarnpkg.com/)
  - [Github Cli](https://cli.github.com/manual/gh)

## Getting Started

### Running with Docker Compose

To start the application within Docker Compose:

```bash
docker compose up
```

If you want to force a rebuild:

```bash
docker compose up --build
```

Alternatively, you can set up only PostgreSQL:

```bash
docker compose up -d postgres
```

### Setup dependencies with asdf (optional)

Add all required plugins from `.tool-versions`

```bash
cat .tool-versions | awk '{print $1}' | xargs -I {} asdf plugin add {}
```

Install all dependencies

```bash
asdf install
```

### Checking quality

1. You can run `mix credo`for static analysis.
2. Run `MIX_ENV=test mix setup` to set up database for tests.
3. You can run `mix test` for unit testing.

### Running Locally

To start your Phoenix server locally:

1. Run `mix setup` to install and set up dependencies.
2. Start the Phoenix endpoint with:

```bash
mix phx.server
```

Or, inside IEx with:

```bash
iex -S mix phx.server
```

Visit [`localhost:4000`](http://localhost:4000) from your browser to view the application.