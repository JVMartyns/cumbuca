defmodule CumbucaWeb.Token do
  alias Cumbuca.Accounts.Account
  alias CumbucaWeb.Endpoint
  alias Phoenix.Token

  @default_ttl 86400

  def create(%Account{id: id}) do
    Token.sign(Endpoint, salt(), %{id: id})
  end

  def verify(token) do
    case Token.verify(Endpoint, salt(), token, max_age: ttl()) do
      {:ok, _} = response ->
        response

      _error ->
        {:error, :unauthorized}
    end
  end

  defp salt, do: Application.fetch_env!(:cumbuca, :token)[:salt]

  defp ttl do
    :cumbuca
    |> Application.fetch_env!(:token)
    |> Map.get(:ttl)
    |> String.to_integer()
  rescue
    _ -> @default_ttl
  end
end
