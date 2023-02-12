defmodule CumbucaWeb.AuthPlug do
  @moduledoc false
  import Plug.Conn
  alias CumbucaWeb.{ErrorView, Token}
  alias Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, %{id: account_id}} <- Token.verify(token) do
      assign(conn, :account_id, account_id)
    else
      _error ->
        handle_error(conn)
    end
  end

  defp handle_error(conn) do
    conn
    |> put_status(:unauthorized)
    |> Controller.put_view(ErrorView)
    |> Controller.render("401.json")
    |> halt()
  end
end
