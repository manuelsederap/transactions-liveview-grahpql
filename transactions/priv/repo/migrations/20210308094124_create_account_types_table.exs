defmodule TransactionsGraphql.Repo.Migrations.CreateAccountTypesTable do
  use Ecto.Migration
  @moduledoc """
    Create account_type table migration schema
  """

  def up do
    create table(:account_types) do
      add :name, :string
      add :transactions, :integer
      add :deleted, :boolean
      
      timestamps(inserted_at: :created_at)
    end

    create unique_index(:account_types, [:name])
  end

  def down do
    drop table(:account_types)
  end
end
