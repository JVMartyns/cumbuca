defmodule Cumbuca.Transactions.BuildTransference do
  alias Cumbuca.Accounts
  alias Cumbuca.Transactions.Transaction

  def call(sender_account_id, receiver_account_cpf, value) do
    with {:ok, sender_account} <- Accounts.get_account_by_id(sender_account_id),
         {:ok, receiver_account} <- Accounts.get_account_by_cpf(receiver_account_cpf),
         {:ok, :has_balance} <- Accounts.check_balance(sender_account, value) do
      Transaction.build(%{
        sender_account_id: sender_account.id,
        receiver_account_id: receiver_account.id,
        value: value
      })
    end
  end
end
