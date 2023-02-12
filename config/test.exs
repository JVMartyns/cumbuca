import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :cumbuca, Cumbuca.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "cumbuca_db",
  database: "cumbuca_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cumbuca, CumbucaWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "nQoTy9BD6CXkzmK3Xl+dyZs5/HBmvG0Q7cTC0meOLQWxjyODfEfTYhKaYPV9/VYa",
  server: false

# In test we don't send emails.
config :cumbuca, Cumbuca.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :cumbuca, :token,
  salt: System.get_env("TOKEN_SALT", "aBBG28Kxn1JWuaxyiZBgoYSpR//ybu9STnRE2UdYOw0="),
  ttl: System.get_env("TOKEN_TTL", "86400")
