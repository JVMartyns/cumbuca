defmodule Cumbuca.Accounts.CheckBalanceTest do
  use Cumbuca.DataCase
  alias Cumbuca.Accounts.CheckBalance
  import Cumbuca.Factory

  describe "call/1" do
    test "when the account has enough balance" do
      account = insert(:account, balance: 100)
      assert CheckBalance.call(account, 100) == {:ok, :has_balance}
    end

    test "when the account no has enough balance" do
      account = insert(:account, balance: 100)
      assert CheckBalance.call(account, 200) == {:error, :insuficiente_founds}
    end
  end
end
