defmodule Cumbuca.Transactions.GetTransactionById do
  @moduledoc false
  alias Cumbuca.Repo
  alias Cumbuca.Transactions.Transaction

  def call(transaction_id) do
    case Repo.get(Transaction, transaction_id) do
      %Transaction{} = result -> {:ok, result}
      nil -> {:error, "transaction not found for [id: #{transaction_id}]"}
    end
  end
end
