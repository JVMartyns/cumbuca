defmodule Cumbuca.Accounts.UpdateAccount do
  @moduledoc false
  alias Cumbuca.Accounts.Account
  alias Cumbuca.Repo

  def call(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end
end
