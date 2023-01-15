defmodule Cumbuca.Accounts do
  alias __MODULE__.{
    CreateAccount,
    GetAccountByCpf
  }

  defdelegate create_account(attrs), to: CreateAccount, as: :call
  defdelegate get_account_by_cpf(cpf), to: GetAccountByCpf, as: :call
end
