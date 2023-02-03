defmodule Cumbuca.Transactions do
  alias __MODULE__.{
    CreateTransaction,
    GetAllTransactions,
    GetTransactionById,
    BuildTransference,
    InsertTransaction,
    PreloadAssoc,
    ProcessChargeback,
    ProcessTransaction,
    UpdateTransaction
  }

  defdelegate get_transaction_by_id(transaction_id), to: GetTransactionById, as: :call

  defdelegate get_all_transactions(account_id), to: GetAllTransactions, as: :call

  defdelegate create_transaction(sender_account_id, receiver_account_cpf, value),
    to: CreateTransaction,
    as: :call

  defdelegate build_transaction(sender_account_id, receiver_account_cpf, value),
    to: BuildTransference,
    as: :call

  defdelegate insert_transaction(transaction), to: InsertTransaction, as: :call
  defdelegate process_chargeback(transaction_id), to: ProcessChargeback, as: :call
  defdelegate process_transaction(transaction_id), to: ProcessTransaction, as: :call

  defdelegate preload_assoc(transaction, preloads), to: PreloadAssoc, as: :call

  defdelegate update_transaction(transaction, attrs, opts \\ []), to: UpdateTransaction, as: :call
end
