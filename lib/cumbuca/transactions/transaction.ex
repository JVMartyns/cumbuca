defmodule Cumbuca.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cumbuca.Accounts.Account

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime]
  @required_fields ~w(sender_account_id receiver_account_id value)a
  @optional_fields ~w(chargeback? processed_at reversed_transaction_id)a

  schema "transactions" do
    field :chargeback?, :boolean, default: false
    field :processed_at, :utc_datetime
    field :value, :decimal

    belongs_to :sender_account, Account
    belongs_to :receiver_account, Account
    belongs_to :reversed_transaction, Account

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:value, greater_than: 0)
  end

  def build(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> apply_action(:build)
  end
end
