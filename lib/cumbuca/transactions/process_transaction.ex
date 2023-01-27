defmodule Cumbuca.Transactions.ProcessTransaction do
  alias Cumbuca.{Accounts, Repo, Transactions}
  alias Ecto.Multi

  def call(transaction_id) do
    with {:ok, transaction} <- Transactions.get_transaction_by_id(transaction_id),
         {:ok, %{transaction: result}} <- process_transaction(transaction) do
      {:ok, result}
    end
  end

  defp process_transaction(transaction) do
    Multi.new()
    |> Multi.run(:preloads, fn _, _ -> preload_assoc(transaction) end)
    |> Multi.run(:sender_account, &subtract_value_from_account/2)
    |> Multi.run(:receiver_account, &add_value_into_receiver_account/2)
    |> Multi.run(:transaction, &update_transaction_status/2)
    |> Repo.transaction()
  end

  defp preload_assoc(transaction) do
    Transactions.preload_assoc(transaction, [:sender_account, :receiver_account])
  end

  defp subtract_value_from_account(_repo, %{
         preloads: %{sender_account: sender_account, value: value}
       }) do
    new_balance = Decimal.sub(sender_account.balance, value)
    Accounts.update_account(sender_account, %{balance: new_balance})
  end

  defp add_value_into_receiver_account(_repo, %{
         preloads: %{receiver_account: receiver_account, value: value}
       }) do
    new_balance = Decimal.add(receiver_account.balance, value)
    Accounts.update_account(receiver_account, %{balance: new_balance})
  end

  defp update_transaction_status(_repo, %{preloads: transaction}) do
    datetime = %{DateTime.utc_now() | microsecond: {0, 0}}
    fields_to_preload = [:sender_account, :receiver_account]

    case Transactions.update_transaction(transaction, %{processed_at: datetime}) do
      {:ok, result} ->
        {:ok, Repo.preload(result, fields_to_preload, force: true)}

      error ->
        error
    end
  end
end
