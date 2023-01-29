defmodule CumbucaWeb.TransactionView do
  use CumbucaWeb, :view
  alias Cumbuca.Accounts.Account
  alias Cumbuca.Transactions.Transaction

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, __MODULE__, "transaction.json")}
  end

  def render("show.json", %{transactions: transactions}) do
    %{data: render_many(transactions, __MODULE__, "transaction.json")}
  end

  def render("transaction.json", %{transaction: %Transaction{} = transaction}) do
    %Account{} = sender_account = transaction.sender_account
    %Account{} = receiver_account = transaction.receiver_account

    %{
      id: transaction.id,
      sender_account: %{
        name: "#{sender_account.first_name} #{sender_account.last_name}",
        cpf: sender_account.cpf
      },
      receiver_account: %{
        name: "#{receiver_account.first_name} #{receiver_account.last_name}",
        cpf: receiver_account.cpf
      },
      value: transaction.value,
      processed_at: transaction.processed_at,
      chargeback?: transaction.chargeback?,
      reversed_transaction_id: transaction.reversed_transaction_id
    }
  end
end
