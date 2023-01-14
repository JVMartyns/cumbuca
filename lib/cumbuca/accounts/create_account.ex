defmodule Cumbuca.Accounts.CreateAccount do
  alias Cumbuca.Accounts.Account
  alias Cumbuca.Repo

  def call(attrs) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end
end
