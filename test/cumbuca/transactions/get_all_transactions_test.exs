defmodule Cumbuca.Transactions.GetAllTransactionsTest do
  use Cumbuca.DataCase
  alias Cumbuca.Transactions.{GetAllTransactions, Transaction}
  import Cumbuca.Factory

  describe "call/1" do
    test "get all transactions" do
      %{id: sender_account_id} = sender_account = insert(:account)
      %{id: receiver_account_id} = receiver_account = insert(:account)

      %{id: transaction_id, value: value, processed_at: processed_at} =
        insert(:transaction,
          sender_account_id: sender_account_id,
          receiver_account_id: receiver_account_id
        )

      assert [
               %Transaction{
                 id: ^transaction_id,
                 chargeback?: false,
                 processed_at: ^processed_at,
                 value: ^value,
                 sender_account_id: ^sender_account_id,
                 sender_account: ^sender_account,
                 receiver_account_id: ^receiver_account_id,
                 receiver_account: ^receiver_account
               }
             ] = GetAllTransactions.call(sender_account_id)
    end

    test "when there are no transactions" do
      %{id: sender_account_id} = insert(:account)

      assert GetAllTransactions.call(sender_account_id) == []
    end
  end
end
