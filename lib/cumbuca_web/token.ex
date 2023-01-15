defmodule CumbucaWeb.Token do
  alias Cumbuca.Accounts.Account
  alias CumbucaWeb.Endpoint
  alias Phoenix.Token

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
  defp ttl, do: Application.fetch_env!(:cumbuca, :token)[:ttl]
end
