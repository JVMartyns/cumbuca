defmodule Cumbuca.Accounts.CheckBalance do
  @moduledoc false
  alias Cumbuca.Accounts.Account

  def call(%Account{balance: balance}, value) do
    case Decimal.compare(balance, Decimal.new(value)) do
      result when result in [:gt, :eq] -> {:ok, :has_balance}
      :lt -> {:error, :insuficiente_founds}
    end
  end
end
