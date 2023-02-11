defmodule CumbucaWeb.FallbackController do
  use CumbucaWeb, :controller
  alias CumbucaWeb.{ChangesetView, ErrorView}

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("401.json")
  end

  def call(conn, {:error, status, message}) do
    conn
    |> put_status(status)
    |> put_view(ErrorView)
    |> render("error_message.json", message: message)
  end
end
