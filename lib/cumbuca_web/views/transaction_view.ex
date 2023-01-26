defmodule CumbucaWeb.TransactionView do
  use CumbucaWeb, :view

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, __MODULE__, "transaction.json")}
  end

  def render("show.json", %{transactions: transactions}) do
    %{data: render_many(transactions, __MODULE__, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{
      id: transaction.id,
      sender_account: transaction.sender_account.cpf,
      receiver_account: transaction.receiver_account.cpf,
      value: transaction.value,
      processed_at: transaction.processed_at,
      chargeback?: transaction.chargeback?,
      reversed_transaction_id: transaction.reversed_transaction_id
    }
  end
end
