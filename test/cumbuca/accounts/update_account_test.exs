defmodule Cumbuca.Accounts.UpdateAccountTest do
  use Cumbuca.DataCase
  import Cumbuca.Factory
  alias Cumbuca.Accounts.{Account, UpdateAccount}

  describe "call/2" do
    test "update account" do
      account = insert(:account, balance: 100)

      new_attrs = %{
        balance: 200
      }

      assert {:ok, %Account{balance: balance}} = UpdateAccount.call(account, new_attrs)
      assert balance == Decimal.new(new_attrs.balance)
    end

    test "when attrs is not valid" do
      account = insert(:account, balance: 100)

      new_attrs = %{
        balance: "invalid_balance"
      }

      assert {:error, changeset} = UpdateAccount.call(account, new_attrs)
      assert errors_on(changeset) == %{balance: ["is invalid"]}
    end
  end
end
