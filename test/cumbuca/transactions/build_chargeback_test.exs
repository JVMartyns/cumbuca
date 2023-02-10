defmodule Cumbuca.Transactions.BuildChargebackTest do
  use Cumbuca.DataCase
  import Cumbuca.Factory
  alias Cumbuca.Accounts.Account
  alias Cumbuca.Repo
  alias Cumbuca.Transactions.BuildChargeback

  describe "call/2" do
    test "when params are valid, build an chargeback" do
      transaction = insert(:transaction)
      current_account_id = transaction.receiver_account_id

      assert {:ok, chargeback} = BuildChargeback.call(current_account_id, transaction)

      assert chargeback.reversed_transaction_id == transaction.id
      assert chargeback.sender_account_id == current_account_id
      assert chargeback.value == transaction.value
    end

    test "when there is no balance available for refund" do
      transaction =
        :transaction
        |> insert()
        |> Repo.preload(:receiver_account)

      transaction.receiver_account
      |> Account.changeset(%{balance: Decimal.new(0)})
      |> Repo.update()

      current_account_id = transaction.receiver_account_id
      expected_result = {:error, :insuficiente_founds}

      result = BuildChargeback.call(current_account_id, transaction)

      assert result == expected_result
    end

    test "when the current account is not the receiver account" do
      transaction = insert(:transaction)
      current_account_id = transaction.sender_account_id
      expected_result = {:error, "unable to chargeback"}

      result = BuildChargeback.call(current_account_id, transaction)

      assert result == expected_result
    end

    test "when the transaction has already been refunded" do
      transaction = insert(:transaction)
      insert(:transaction, reversed_transaction_id: transaction.id)
      current_account_id = transaction.receiver_account_id
      expected_result = {:error, "unable to chargeback"}

      result = BuildChargeback.call(current_account_id, transaction)

      assert result == expected_result
    end
  end
end
