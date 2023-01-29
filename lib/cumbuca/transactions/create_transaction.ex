defmodule Cumbuca.Transactions.CreateTransaction do
  alias Cumbuca.Transactions
  alias Transactions.Transaction

  @type value :: integer | float | binary

  @spec call(Ecto.UUID.t(), String.t(), value) :: {:ok, Transaction.t()} | {:error, any()}
  def call(sender_account_id, receiver_account_cpf, value) do
    with {:ok, builded_transaction} <-
           Transactions.build_transaction(sender_account_id, receiver_account_cpf, value),
         {:ok, transaction} <- Transactions.insert_transaction(builded_transaction) do
      Transactions.preload_assoc(transaction, [:sender_account, :receiver_account])
    end
  end
end
