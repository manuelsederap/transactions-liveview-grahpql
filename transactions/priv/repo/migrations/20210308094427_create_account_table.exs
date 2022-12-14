defmodule TransactionsGraphql.Repo.Migrations.CreateAccountTable do
  use Ecto.Migration
  @moduledoc """
    Create account_table migration schema.
  """

  def up do
    create table(:accounts) do
      add :name, :string
      add :balance_start, :float
      add :type, references(:account_types, column: :name, type: :string)
      add :transactions, :integer
      add :deleted, :boolean
      
      timestamps(inserted_at: :created_at)
    end

    create unique_index(:accounts, [:name])
  end

  def down do
    drop table(:accounts)
  end
end
