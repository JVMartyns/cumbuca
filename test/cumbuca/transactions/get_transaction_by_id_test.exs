defmodule Cumbuca.Transactions.GetTransactionByIdTest do
  use Cumbuca.DataCase
  alias Cumbuca.Transactions.{Transaction, GetTransactionById}
  import Cumbuca.Factory

  describe "call/1" do
    test "get transaction by id" do
      %{id: id} =
        insert(:transaction,
          sender_account_id: insert(:account).id,
          receiver_account_id: insert(:account).id
        )

      assert {:ok, %Transaction{id: ^id}} = GetTransactionById.call(id)
    end

    test "when transaction is not found" do
      id = Ecto.UUID.generate()
      assert {:error, "transaction not found for " <> params} = GetTransactionById.call(id)
      assert params == "[id: #{id}]"
    end
  end
end
