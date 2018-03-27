# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ticcattoe, ecto_repos: [Ticcattoe.Repo]

# Configures the endpoint
config :ticcattoe, TiccattoeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QJD2XWdHILo/VvIHr1m84iiPoi/iUNH/okLNcjrj1T8kSz4usY6/OimkGOcteVCO",
  render_errors: [view: TiccattoeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ticcattoe.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
