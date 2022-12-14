defmodule TransactionsGraphql.Repo.Migrations.CreateTransactionCategoryTable do
  use Ecto.Migration
  @moduledoc """
    Create transaction_category table Migration schema.
  """

  def up do
    create table(:transaction_categories) do
      add :name, :string
      add :transactions, :integer
      add :deleted, :boolean
      
      timestamps(inserted_at: :created_at)

    end
    
    create unique_index(:transaction_categories, [:name])
  end

  def down do
    drop table(:transaction_categories)
  end
end
