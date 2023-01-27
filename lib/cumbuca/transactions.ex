defmodule Cumbuca.Transactions do
  alias __MODULE__.{
    GetAllTransactions,
    GetTransactionById,
    BuildTransaction,
    InsertTransaction,
    PreloadAssoc,
    ProcessTransaction,
    UpdateTransaction
  }

  defdelegate get_transaction_by_id(transaction_id), to: GetTransactionById, as: :call

  defdelegate get_all_transactions(account_id), to: GetAllTransactions, as: :call

  defdelegate build_transaction(sender_account_id, receiver_account_cpf, value),
    to: BuildTransaction,
    as: :call

  defdelegate insert_transaction(transaction), to: InsertTransaction, as: :call

  defdelegate process_transaction(transaction_id), to: ProcessTransaction, as: :call

  defdelegate preload_assoc(transaction, preloads), to: PreloadAssoc, as: :call

  defdelegate update_transaction(transaction, attrs, opts \\ []), to: UpdateTransaction, as: :call
end
