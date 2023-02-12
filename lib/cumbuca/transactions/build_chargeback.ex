defmodule Cumbuca.Transactions.BuildChargeback do
  @moduledoc false
  import Ecto.Query
  alias Cumbuca.Accounts
  alias Cumbuca.Repo
  alias Cumbuca.Transactions.Transaction

  def call(current_account_id, %Transaction{} = transaction) do
    with true <- enabled_to_chargeback?(current_account_id, transaction),
         {:ok, current_account} <- Accounts.get_account_by_id(current_account_id),
         {:ok, :has_balance} <- Accounts.check_balance(current_account, transaction.value) do
      Transaction.build(%{
        reversed_transaction_id: transaction.id,
        sender_account_id: transaction.receiver_account_id,
        receiver_account_id: transaction.sender_account_id,
        value: transaction.value,
        chargeback?: true
      })
    else
      false ->
        {:error, "unable to chargeback"}

      error ->
        error
    end
  end

  defp enabled_to_chargeback?(current_account_id, transaction) do
    query = from t in Transaction, where: t.reversed_transaction_id == ^transaction.id
    Repo.exists?(query) == false and current_account_id == transaction.receiver_account_id
  end
end
