defmodule Cumbuca.Accounts do
  alias __MODULE__.{
    CheckBalance,
    CreateAccount,
    GetAccountByCpf,
    GetAccountById,
    UpdateAccount
  }

  defdelegate create_account(attrs), to: CreateAccount, as: :call
  defdelegate get_account_by_cpf(cpf), to: GetAccountByCpf, as: :call
  defdelegate get_account_by_id(id), to: GetAccountById, as: :call
  defdelegate check_balance(account, value), to: CheckBalance, as: :call
  defdelegate update_account(account, attrs), to: UpdateAccount, as: :call
end
