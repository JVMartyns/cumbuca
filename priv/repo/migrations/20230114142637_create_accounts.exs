defmodule Cumbuca.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def up do
    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string
      add :last_name, :string
      add :cpf, :string
      add :balance, :decimal

      timestamps()
    end

    create unique_index(:accounts, :cpf)
  end

  def down do
    drop table(:accounts)
  end
end
