defmodule Cumbuca.Accounts.Account do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Cumbuca.EctoTypes.EncryptedString

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime]
  @required_fields ~w(first_name last_name cpf password)a
  @optional_fields ~w(balance)a

  schema "accounts" do
    field :cpf, EncryptedString
    field :password, EncryptedString
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
    |> validate_cpf()
    |> unique_constraint(:cpf)
    |> check_constraint(:balance, name: :balance_must_be_positive)
  end

  defp validate_cpf(changeset) do
    changeset
    |> validate_format(:cpf, ~r/^(\d{11})$/)
    |> validate_change(:cpf, fn :cpf, cpf ->
      if Cpf.valid?(cpf), do: [], else: [cpf: "is invalid"]
    end)
    |> unique_constraint(:cpf)
  end
end
