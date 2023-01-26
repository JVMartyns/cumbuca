defmodule Cumbuca.Transactions.InsertTransaction do
  alias Cumbuca.Repo
  alias Cumbuca.Transactions.Transaction

  def call(%Transaction{} = transaction), do: Repo.insert(transaction)

  def call(attrs) when is_map(attrs) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end
end
