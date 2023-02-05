defmodule Cumbuca.EctoTypes.EncryptedString do
  use Ecto.Type

  def type, do: :string

  def cast(str) when is_binary(str), do: {:ok, str}
  def cast(_), do: :error

  def load(data) when is_binary(data), do: {:ok, Base.decode64!(data)}

  def dump(str) when is_binary(str), do: {:ok, Base.encode64(str)}
  def dump(_), do: :error
end
