# Ascend

A Phoenix Liveview explorer for UK and Irish Mountains

Written to explore liveview and consolidate my thinking around contexts.

Data is from the wonderful [The Database of British and Irish Hills](http://www.hills-database.co.uk/)
Well worth reading the [database notes](http://www.hills-database.co.uk/database_notes.html).

### Setup

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

The data is stored in a csv found in `priv/data/dobish.csv`, and you can import it locally from a console via:
`Import.Dobih.import("priv/data/dobih.csv")`

Tests can be run via `mix test`

### Deployment

A running example can be found at [Ascend on Fly.io](https://ascend.fly.dev).

Presently running within the free allowances of the [Fly.io](https://fly.io/) platform.

To run your own instance of ascend, modify the fly.toml file to point to your own setup on Fly.io.

It's using sqlite3, so a volume is highly recommended, 1Gb is ample.

To connect to a running console run:
`fly ssh console`

Then run the following commands:
`app/bin/ascend remote`

The priv folder isn't immediately accessible in production environment as it's in a release. To load the data in production:
1. Scale the app to 1GB memory
2. Connect to the new instance console
3. Run `Path.join(Application.app_dir(:ascend, "priv"), "data/dobih.csv") |> Import.Dobih.import`
4. Exit and scale down the app to the default 256MB


## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
