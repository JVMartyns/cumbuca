defmodule Cumbuca.Accounts.GetAccountByCpf do
  import Ecto.Query
  alias Cumbuca.Accounts.Account
  alias Cumbuca.Repo

  def call(cpf) do
    query = from a in Account, where: a.cpf == ^cpf

    case Repo.one(query) do
      nil -> {:error, "account not found for [cpf: #{cpf}]"}
      result -> {:ok, result}
    end
  end
end
