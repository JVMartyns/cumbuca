defmodule Cumbuca.Transactions.InsertTransactionTest do
  use Cumbuca.DataCase
  alias Cumbuca.Transactions.{InsertTransaction, Transaction}
  import Cumbuca.Factory

  describe "call/1" do
    test "insert an valid transaction" do
      %{id: sender_account_id} = insert(:account)
      %{id: receiver_account_id} = insert(:account)

      transaction =
        params_for(:transaction,
          sender_account_id: sender_account_id,
          receiver_account_id: receiver_account_id
        )

      assert {:ok,
              %Transaction{
                sender_account_id: ^sender_account_id,
                receiver_account_id: ^receiver_account_id
              }} = InsertTransaction.call(transaction)
    end
  end
end
