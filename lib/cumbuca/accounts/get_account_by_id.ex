defmodule Cumbuca.Accounts.GetAccountById do
  alias Cumbuca.Accounts.Account
  alias Cumbuca.Repo

  def call(id) do
    case Repo.get(Account, id) do
      %Account{} = account -> {:ok, account}
      nil -> {:error, "account not found for [id: #{id}]"}
    end
  end
end
