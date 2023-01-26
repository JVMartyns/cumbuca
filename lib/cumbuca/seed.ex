defmodule Cumbuca.Seed do
  alias Cumbuca.Accounts
  alias Cumbuca.Transactions

  def run do
    {:ok, sender_account} =
      Accounts.create_account(%{
        first_name: "Za",
        last_name: "Warudo",
        cpf: "61056482001",
        password: "12345678",
        balance: "100"
      })

    {:ok, receiver_account} =
      Accounts.create_account(%{
        first_name: "Za",
        last_name: "Warudo",
        cpf: "66950171072",
        password: "12345678",
        balance: "100"
      })

    {:ok, builded_transaction} =
      Transactions.build_transaction(sender_account.id, receiver_account.cpf, 100)

    Transactions.insert_transaction(builded_transaction)
  end
end
