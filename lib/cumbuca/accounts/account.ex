defmodule Cumbuca.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime]
  @required_fields ~w(first_name last_name cpf)a
  @optional_fields ~w(balance)a

  schema "accounts" do
    field :cpf, :string
    field :first_name, :string
    field :last_name, :string
    field :balance, :decimal, default: Decimal.new(0)

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:balance, greater_than_or_equal_to: 0)
    |> validate_format(:cpf, ~r/^(\d{11})$/)
    |> unique_constraint(:cpf)
  end
end
