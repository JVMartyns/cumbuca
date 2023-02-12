defmodule Cumbuca.Transactions.PreloadAssoc do
  @moduledoc false
  alias Cumbuca.Repo
  alias Cumbuca.Transactions.Transaction

  def call(%Transaction{} = transaction, preloads) when is_list(preloads) do
    case Repo.preload(transaction, preloads) do
      %Transaction{} = result -> {:ok, result}
      error -> error
    end
  end
end
