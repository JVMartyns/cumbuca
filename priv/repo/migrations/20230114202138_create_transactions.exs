defmodule Cumbuca.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def up do
    create table(:transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :processed_at, :utc_datetime
      add :chargeback?, :boolean, default: false
      add :value, :decimal
      add :sender_account_id, references(:accounts, type: :binary_id)
      add :receiver_account_id, references(:accounts, type: :binary_id)
      add :reversed_transaction_id, references(:transactions, type: :binary_id)

      timestamps()
    end

    create index(:transactions, [:sender_account_id])
    create index(:transactions, [:receiver_account_id])
    create index(:transactions, [:reversed_transaction_id])
  end

  def down do
    drop index(:transactions, [:sender_account_id])
    drop index(:transactions, [:receiver_account_id])
    drop index(:transactions, [:reversed_transaction_id])
    drop table(:transactions)
  end
end
