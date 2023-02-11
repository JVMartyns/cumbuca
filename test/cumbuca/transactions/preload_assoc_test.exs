defmodule Cumbuca.Transactions.PreloadAssocTest do
  use Cumbuca.DataCase
  import Cumbuca.Factory
  alias Cumbuca.Transactions.{PreloadAssoc, Transaction}

  describe "call/1" do
    test "load associated accounts" do
      sender_account = insert(:account)
      receiver_account = insert(:account)

      transaction =
        insert(:transaction,
          sender_account_id: sender_account.id,
          receiver_account_id: receiver_account.id
        )

      associations = [:sender_account, :receiver_account]

      assert {:ok,
              %Transaction{
                sender_account: ^sender_account,
                receiver_account: ^receiver_account
              }} = PreloadAssoc.call(transaction, associations)
    end
  end
end
