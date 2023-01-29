defmodule Cumbuca.EctoTypes.EncryptedString do
  use Ecto.Type
  alias Cumbuca.Crypto
  def type, do: :string

  def cast(str) when is_binary(str), do: {:ok, String.trim(str)}
  def cast(_), do: :error

  def load(data) when is_binary(data) do
    {:ok, Crypto.decrypt(data)}
  end

  def dump(str) when is_binary(str), do: {:ok, Crypto.encrypt(str)}
  def dump(_), do: :error
end
