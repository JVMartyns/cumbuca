defmodule Cumbuca.Transactions.BuildTransferenceTest do
  use Cumbuca.DataCase
  import Cumbuca.Factory
  alias Cumbuca.Transactions.{BuildTransference, Transaction}

  describe "call/1" do
    test "when all params are valid" do
      %{id: sender_account_id} = insert(:account)
      %{id: receiver_account_id, cpf: receiver_account_cpf} = insert(:account)
      value = 100
      decimal_value = Decimal.new(value)

      assert {:ok, result} =
               BuildTransference.call(sender_account_id, receiver_account_cpf, value)

      assert %Transaction{
               sender_account_id: ^sender_account_id,
               receiver_account_id: ^receiver_account_id,
               value: ^decimal_value,
               chargeback?: false,
               reversed_transaction_id: nil,
               processed_at: nil
             } = result
    end

    test "when the account has enough balance" do
      %{id: sender_account_id} = insert(:account, balance: 0)
      %{cpf: receiver_account_cpf} = insert(:account)
      value = 100

      assert BuildTransference.call(sender_account_id, receiver_account_cpf, value) ==
               {:error, :insuficiente_founds}
    end
  end
end
