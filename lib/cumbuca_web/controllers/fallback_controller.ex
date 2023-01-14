defmodule CumbucaWeb.FallbackController do
  use CumbucaWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(CumbucaWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(CumbucaWeb.ErrorView)
    |> render("401.json")
  end
end
