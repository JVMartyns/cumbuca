defmodule Cumbuca.Transactions.UpdateTransaction do
  alias Cumbuca.Repo
  alias Cumbuca.Transactions.Transaction

  def call(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end
end
