defmodule Cumbuca.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: Cumbuca.Repo
  use __MODULE__.{AccountFactory, TransactionsFactory}
end
