defmodule Cumbuca.Accounts do
  alias __MODULE__.{CreateAccount}

  defdelegate create_account(attrs), to: CreateAccount, as: :call
end
