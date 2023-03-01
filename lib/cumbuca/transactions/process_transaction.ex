defmodule Cumbuca.Transactions.ProcessTransaction do
  @moduledoc false
  import Ecto.Query
  alias Ecto.Multi

  alias Cumbuca.{
    Accounts,
    Accounts.Account,
    Repo,
    Transactions,
    Transactions.Transaction
  }

  @spec call(Ecto.UUID) :: {:ok, Transaction.t()} | {:error, any()}
  def call(transaction_id) do
    Repo.transaction(fn ->
      Repo.query!("set transaction isolation level repeatable read;")
      process_transaction(transaction_id)
    end)
    |> case do
      {:ok, {:ok, %{update_transaction: transaction}}} -> {:ok, transaction}
      {:error, _} = error -> error
    end
  end

  def process_transaction(transaction_id) do
    Multi.new()
    |> Multi.run(:load_data, fn _, _ -> load_transaction_data(transaction_id) end)
    |> Multi.run(:check, &perform_transaction_check/2)
    |> Multi.run(:subtract_balance, &subtract_balance_from_account/2)
    |> Multi.run(:add_balance, &add_balance_into_account/2)
    |> Multi.run(:update_transaction, &update_transaction_status/2)
    |> Repo.transaction()
  end

  defp perform_transaction_check(_repo, %{
         load_data: %Transaction{sender_account: sender, value: value} = transaction
       }) do
    with {:ok, _} <- check_processing_status(transaction),
         {:ok, _} <- check_chargeback_status(transaction),
         {:ok, _} <- Accounts.check_balance(sender, value) do
      {:ok, transaction}
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

  defp load_transaction_data(transaction_id) do
    with {:ok, transaction} <- Transactions.get_transaction_by_id(transaction_id) do
      Transactions.preload_assoc(transaction, [:sender_account, :receiver_account])
    end
  end

  defp subtract_balance_from_account(_repo, %{
         load_data: %Transaction{sender_account: account, value: value}
       }) do
    Accounts.update_account(account, %{balance: Decimal.sub(account.balance, value)})
  end

  defp add_balance_into_account(_repo, %{
         load_data: %Transaction{receiver_account: account, value: value}
       }) do
    Accounts.update_account(account, %{balance: Decimal.add(account.balance, value)})
  end

  defp update_transaction_status(_repo, %{
         load_data: %Transaction{} = transaction,
         subtract_balance: %Account{} = sender_account,
         add_balance: %Account{} = receiver_account
       }) do
    attrs = %{processed_at: %{DateTime.utc_now() | microsecond: {0, 0}}}

    case Transactions.update_transaction(transaction, attrs) do
      {:ok, updated_transaction} ->
        {:ok,
         %Transaction{
           updated_transaction
           | sender_account: sender_account,
             receiver_account: receiver_account
         }}

      error ->
        error
    end
  end
end
