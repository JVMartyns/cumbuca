defmodule Cumbuca.Common.ExternalToInternal do
  def call(:date, external_date) when is_binary(external_date) do
    case Date.from_iso8601(external_date) do
      {:ok, date} -> date
      {:error, _} -> nil
    end
  end

  def call(:date, _external_date), do: nil
end
