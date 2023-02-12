defmodule Cumbuca.Accounts.CreateAccount do
  @moduledoc false
  alias Cumbuca.Accounts.Account
  alias Cumbuca.Repo

  def call(attrs) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end
end
