defmodule Cumbuca.Transactions.GetAllTransactions do
  @moduledoc false
  import Ecto.Query
  alias Cumbuca.Repo
  alias Cumbuca.Transactions.Transaction

  def call(account_id, opts \\ []) do
    from(t in Transaction)
    |> where([t], t.sender_account_id == ^account_id or t.receiver_account_id == ^account_id)
    |> where([t], not is_nil(t.processed_at))
    |> maybe_filter_by_initial_date(opts[:initial_date])
    |> maybe_filter_by_final_date(opts[:final_date])
    |> Repo.all()
    |> Repo.preload([:sender_account, :receiver_account])
  end

  defp maybe_filter_by_initial_date(query, %Date{} = initial_date) do
    where(query, [t], fragment("?::date", t.processed_at) >= ^initial_date)
  end

  defp maybe_filter_by_initial_date(query, _), do: query

  defp maybe_filter_by_final_date(query, %Date{} = final_date) do
    where(query, [t], fragment("?::date", t.processed_at) <= ^final_date)
  end

  defp maybe_filter_by_final_date(query, _), do: query
end
