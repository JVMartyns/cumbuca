defmodule Cumbuca.Transactions.UpdateTransaction do
  @moduledoc false
  alias Cumbuca.Repo
  alias Cumbuca.Transactions.Transaction

  def call(%Transaction{} = transaction, attrs, opts \\ []) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update(opts)
  end
end
