# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :cumbuca,
  ecto_repos: [Cumbuca.Repo]

# Configures the endpoint
config :cumbuca, CumbucaWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: CumbucaWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Cumbuca.PubSub,
  live_view: [signing_salt: "DgkEDOBA"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :cumbuca, Cumbuca.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :cumbuca, :token,
  salt: System.get_env("TOKEN_SALT", "aBBG28Kxn1JWuaxyiZBgoYSpR//ybu9STnRE2UdYOw0="),
  ttl: System.get_env("TOKEN_TTL", "86400")

config :cumbuca, :crypto, secret: System.get_env("CRYPTO_SECRET", "H1vmRcs83J3lT9CSuIx1yQ==")

# Sentry
config :sentry,
  dsn: System.get_env("SENTRY_DNS"),
  included_environments: [:prod],
  environment_name: Mix.env()

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
