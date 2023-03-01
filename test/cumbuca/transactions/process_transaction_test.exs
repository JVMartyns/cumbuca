defmodule Cumbuca.Transactions.ProcessTransactionTest do
  use Cumbuca.DataCase
  import Cumbuca.Factory
  alias Cumbuca.Repo
  alias Cumbuca.Transactions.ProcessTransaction
  alias Ecto.Adapters.SQL.Sandbox

  setup tags do
    :ok =
      if tags[:isolation] do
        Sandbox.checkout(Repo, isolation: tags[:isolation])
      else
        Sandbox.checkout(Repo)
      end

    unless tags[:async] do
      Sandbox.mode(Repo, {:shared, self()})
    end

    :ok
  end

  describe "call/1" do
    @tag isolation: "repeatable read"
    test "process transaction" do
      %{id: sender_account_id, balance: sender_account_balance} = insert(:account)

      %{id: receiver_account_id, balance: receiver_account_balance} = insert(:account)

      %{id: transaction_id} =
        insert(:transaction,
          sender_account_id: sender_account_id,
          receiver_account_id: receiver_account_id,
          processed_at: nil
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
