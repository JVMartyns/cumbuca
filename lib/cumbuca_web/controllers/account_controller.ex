defmodule CumbucaWeb.AccountController do
  use CumbucaWeb, :controller
  alias Cumbuca.Accounts

  action_fallback CumbucaWeb.FallbackController

  def create(conn, attrs) do
    with {:ok, account} <- Accounts.create_account(attrs) do
      conn
      |> put_status(:created)
      |> render("show.json", account: account)
    end
  end
end
