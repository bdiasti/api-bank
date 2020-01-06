# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :api_bank,
  ecto_repos: [ApiBank.Repo]

# Configures the endpoint
config :api_bank, ApiBank.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wodlJUSCKHHl99L73YQ06x/sgKognrk1S2cm56CbVu9Hdh1rAUepzDNT6FTctu1g",
  render_errors: [view: ApiBank.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ApiBank.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# Guardian config
config :api_bank, ApiBank.Guardian,
  issuer: "api_bank",
  secret_key: "e4S8z9YlQEUhJpW8tnV5a60+u+O6dRwk4c1rtkHfZkVrJFOrBRAqhy4/CI5c7Z4Q"

config :api_bank, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      # phoenix routes will be converted to swagger paths
      router: ApiBank.Router,
      # (optional) endpoint config used to set host, port and https schemes.
      endpoint: ApiBank.Endpoint
    ]
  }

config :api_bank, ApiBank.Endpoint,
  # "host": "localhost:4000" in generated swagger
  url: [host: "api-bank.tk"]
