defmodule Cumbuca.Accounts.GetAccountByCpf do
  import Ecto.Query
  alias Cumbuca.Accounts.Account
  alias Cumbuca.Repo

  def call(cpf) do
    query = from a in Account, where: a.cpf == ^cpf

    case Repo.one(query) do
      %Account{} = result -> {:ok, result}
      nil -> {:error, "no result for query: #{inspect(query)}"}
    end
  end
end
