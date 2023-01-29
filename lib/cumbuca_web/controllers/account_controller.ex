defmodule CumbucaWeb.AccountController do
  use CumbucaWeb, :controller
  alias Cumbuca.Accounts
  alias CumbucaWeb.Token

  action_fallback CumbucaWeb.FallbackController

  def create(conn, attrs) do
    with {:ok, account} <- Accounts.create_account(attrs) do
      conn
      |> put_status(:created)
      |> render("show.json", account: account, token: Token.create(account))
    end
  end

  def login(conn, %{"cpf" => cpf, "password" => password}) do
    with {:ok, account} <- Accounts.get_account_by_cpf(cpf),
         true <- account.password == password do
      conn
      |> put_status(:ok)
      |> render("show.json", token: Token.create(account))
    else
      _ -> {:error, :unauthorized}
    end
  end

  def show(%{assigns: %{account_id: id}} = conn, _params) do
    with {:ok, account} <- Accounts.get_account_by_id(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", account: account)
    end
  end
end
