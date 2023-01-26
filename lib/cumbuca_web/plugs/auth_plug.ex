defmodule CumbucaWeb.AuthPlug do
  import Plug.Conn
  alias Phoenix.Controller
  alias CumbucaWeb.Token
  alias CumbucaWeb.ErrorView

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, %{id: account_id}} <- Token.verify(token) do
      assign(conn, :account_id, account_id)
    else
      error ->
        handle_error(conn)
        IO.inspect(error)
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
