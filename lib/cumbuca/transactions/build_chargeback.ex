defmodule Cumbuca.Transactions.BuildChargeback do
  alias Cumbuca.Accounts
  alias Cumbuca.Transactions.Transaction

  def call(current_account_id, %Transaction{} = transaction) do
    with true <- enabled_to_chargeback?(current_account_id, transaction),
         {:ok, current_account} <- Accounts.get_account_by_id(current_account_id),
         {:ok, :has_balance} <- Accounts.check_balance(current_account, transaction.value) do
      Transaction.build(%{
        reversed_transaction_id: transaction.reversed_transaction_id,
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

  defp enabled_to_chargeback?(current_account, transaction) do
    current_account.id == transaction.receiver_account_id
  end
end
