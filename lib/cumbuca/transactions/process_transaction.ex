defmodule Cumbuca.Transactions.ProcessTransaction do
  alias Cumbuca.{Accounts, Repo, Transactions}
  alias Ecto.Multi
  import Ecto.Query
  alias Transactions.Transaction

  def call(transaction_id) do
    with {:ok, transaction} <- Transactions.get_transaction_by_id(transaction_id),
         {:ok, "ready to process"} <- check_processing_status(transaction),
         {:ok, "ready to process"} <- check_chargeback_status(transaction),
         {:ok, %{transaction: result}} <- process_transaction(transaction) do
      {:ok, result}
    end
  end

  defp check_processing_status(%_{processed_at: nil}), do: {:ok, "ready to process"}
  defp check_processing_status(%_{processed_at: _}), do: {:error, "has already processed"}

  defp check_chargeback_status(%{id: transaction_id}) do
    query = from t in Transaction, where: t.reversed_transaction_id == ^transaction_id

    case Repo.exists?(query) do
      false -> {:ok, "ready to process"}
      true -> {:error, "has already been reversed"}
    end
  end

  defp process_transaction(transaction) do
    Multi.new()
    |> Multi.run(:data, fn _, _ -> load_transaction_data(transaction) end)
    |> Multi.run(:sender_account, &subtract_value_from_account/2)
    |> Multi.run(:receiver_account, &add_value_into_receiver_account/2)
    |> Multi.run(:transaction, &update_transaction_status/2)
    |> Repo.transaction()
  end

  defp load_transaction_data(transaction) do
    preloads = [:sender_account, :receiver_account]

    with {:ok, loaded} <- Transactions.preload_assoc(transaction, preloads) do
      {:ok,
       %{
         sender_account: loaded.sender_account,
         receiver_account: loaded.receiver_account,
         transaction: transaction
       }}
    end
  end

  defp subtract_value_from_account(_repo, %{
         data: %{sender_account: sender_account, transaction: transaction}
       }) do
    new_balance = Decimal.sub(sender_account.balance, transaction.value)
    Accounts.update_account(sender_account, %{balance: new_balance})
  end

  defp add_value_into_receiver_account(_repo, %{
         data: %{receiver_account: receiver_account, transaction: transaction}
       }) do
    new_balance = Decimal.add(receiver_account.balance, transaction.value)
    Accounts.update_account(receiver_account, %{balance: new_balance})
  end

  defp update_transaction_status(_repo, %{data: %{transaction: transaction}}) do
    datetime = %{DateTime.utc_now() | microsecond: {0, 0}}
    preloads = [:sender_account, :receiver_account]

    case Transactions.update_transaction(transaction, %{processed_at: datetime}) do
      {:ok, updated_transaction} ->
        Transactions.preload_assoc(updated_transaction, preloads)

      error ->
        error
    end
  end
end
