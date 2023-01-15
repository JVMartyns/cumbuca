defmodule CumbucaWeb.AccountView do
  use CumbucaWeb, :view

  def render("show.json", %{account: account, token: token}) do
    %{
      data: %{
        account: render_one(account, __MODULE__, "account.json"),
        token: token
      }
    }
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, __MODULE__, "account.json")}
  end

  def render("show.json", %{token: token}) do
    %{data: %{token: token}}
  end

  def render("account.json", %{account: account}) do
    %{
      id: account.id,
      first_name: account.first_name,
      last_name: account.last_name,
      cpf: account.cpf,
      password: account.password,
      balance: account.balance,
      inserted_at: account.inserted_at,
      updated_at: account.updated_at
    }
  end
end
