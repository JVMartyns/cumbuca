defmodule Cumbuca.Factory do
  use ExMachina.Ecto, repo: Cumbuca.Repo
  use __MODULE__.{AccountFactory, TransactionsFactory}
end
