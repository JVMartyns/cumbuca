defmodule Cumbuca.Transactions.GetAllTransactions do
  import Ecto.Query
  alias Cumbuca.Repo
  alias Cumbuca.Transactions.Transaction

  def call(account_id) do
    from(t in Transaction)
    |> where([t], t.sender_account_id == ^account_id or t.receiver_account_id == ^account_id)
    |> where([t], not is_nil(t.processed_at))
    |> Repo.all()
    |> Repo.preload([:sender_account, :receiver_account])
  end
end
