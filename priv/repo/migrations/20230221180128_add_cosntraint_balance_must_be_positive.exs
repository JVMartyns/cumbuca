defmodule Cumbuca.Repo.Migrations.AddCosntraintBalanceMustBePositive do
  use Ecto.Migration

  def up do
    create constraint(:accounts, :balance_must_be_positive, check: "balance >= 0")
  end

  def down do
    drop constraint(:accounts, :balance_must_be_positive)
  end
end
