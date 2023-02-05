defmodule Cumbuca.Transactions.CreateChargeback do
  alias Cumbuca.Transactions

  def call(current_account_id, transaction_id) do
    with {:ok, %{chargeback?: false} = transaction} <-
           Transactions.get_transaction_by_id(transaction_id),
         {:ok, builded_chargeback} <-
           Transactions.build_chargeback(current_account_id, transaction),
         {:ok, chargeback} <- Transactions.insert_transaction(builded_chargeback) do
      Transactions.preload_assoc(chargeback, [:sender_account, :receiver_account])
    end
  end
end
