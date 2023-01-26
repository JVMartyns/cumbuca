defmodule Cumbuca.Accounts.GetAccountByIdTest do
  use Cumbuca.DataCase
  alias Cumbuca.Accounts.{Account, GetAccountById}
  import Cumbuca.Factory

  describe "call/1" do
    test "when account exist" do
      %{id: id} = insert(:account)

      assert {:ok, %Account{id: ^id}} = GetAccountById.call(id)
    end

    test "when account does not exist" do
      id = Ecto.UUID.generate()
      assert {:error, "account not found for " <> params} = GetAccountById.call(id)
      assert params == "[id: #{id}]"
    end
  end
end
