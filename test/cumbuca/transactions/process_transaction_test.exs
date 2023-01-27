defmodule Cumbuca.Transactions.ProcessTransactionTest do
  use Cumbuca.DataCase
  import Cumbuca.Factory
  alias Cumbuca.Transactions.ProcessTransaction

  describe "call/1" do
    test " " do
      %{id: sender_account_id, balance: sender_account_balance} = insert(:account)

      %{id: receiver_account_id, balance: receiver_account_balance} = insert(:account)

      %{id: transaction_id} =
        insert(:transaction,
          sender_account_id: sender_account_id,
          receiver_account_id: receiver_account_id
        )

      assert {:ok,
              %{
                id: ^transaction_id,
                processed_at: %DateTime{},
                sender_account: %{balance: new_sender_account_balance},
                receiver_account: %{balance: new_receiver_account_balance}
              }} = ProcessTransaction.call(transaction_id)

      assert Decimal.sub(sender_account_balance, receiver_account_balance) ==
               new_sender_account_balance

      assert Decimal.add(sender_account_balance, receiver_account_balance) ==
               new_receiver_account_balance
    end
  end
end
