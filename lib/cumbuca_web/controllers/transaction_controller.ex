defmodule CumbucaWeb.TransactionController do
  use CumbucaWeb, :controller
  alias Cumbuca.Transactions

  action_fallback CumbucaWeb.FallbackController

  def show(%{assigns: %{account_id: id}} = conn, _attrs) do
    conn
    |> put_status(:ok)
    |> render("show.json", transactions: Transactions.get_all_transactions(id))
  end

  def create_transference(%{assigns: %{account_id: id}} = conn, %{"cpf" => cpf, "value" => value}) do
    case Transactions.create_transaction(id, cpf, value) do
      {:ok, transaction} ->
        conn
        |> put_status(:created)
        |> render("show.json", transaction: transaction)

      {:error, reason} ->
        {:error, 422, reason}
    end
  end

  def process(conn, %{"transaction_id" => transaction_id}) do
    case Transactions.process_transaction(transaction_id) do
      {:ok, transaction} ->
        conn
        |> put_status(:ok)
        |> render("show.json", transaction: transaction)

      {:error, reason} ->
        {:error, 422, reason}
    end
  end

  def chargeback(%{assigns: %{account_id: id}} = conn, %{"transaction_id" => transaction_id}) do
    case Transactions.create_chargeback(id, transaction_id) do
      {:ok, chargeback} ->
        process(conn, %{"transaction_id" => chargeback.id})

      {:error, reason} ->
        {:error, 422, reason}
    end
  end
end
