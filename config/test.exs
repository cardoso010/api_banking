use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.

database_url = "#{System.get_env("DATABASE_URL")}test"

# Configure the database for GitHub Actions
if System.get_env("GITHUB_ACTIONS") do
  config :api_banking, ApiBanking.Repo,
    username: "postgres",
    password: "postgres",
    database: "api_banking_test#{System.get_env("MIX_TEST_PARTITION")}",
    hostname: "localhost",
    pool: Ecto.Adapters.SQL.Sandbox
else
  config :api_banking, ApiBanking.Repo,
    url: database_url,
    pool: Ecto.Adapters.SQL.Sandbox
end

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :api_banking, ApiBankingWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :bcrypt_elixir, :log_rounds, 4
