# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :api_banking,
  ecto_repos: [ApiBanking.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :api_banking, ApiBankingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eNsQ/j7NY9Pa37Ao6TU3lePZ00AMdKAwvlBq58s9YLohitLnyfer1c810WAeAZ8h",
  render_errors: [view: ApiBankingWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ApiBanking.PubSub,
  live_view: [signing_salt: "/sIORHsZ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Guardian config
config :api_banking, ApiBanking.Auth.Guardian,
  issuer: "ApiBanking",
  secret_key: "cdYuBCjXViq7P0ITukMxWjqOcQY9mzndodfedfze6Nqd5IPpgz34528rex/QaPGg"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
