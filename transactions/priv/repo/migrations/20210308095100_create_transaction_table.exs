defmodule TransactionsGraphql.Repo.Migrations.CreateTransactionTable do
  use Ecto.Migration
  @moduledoc """
    Create transaction table migration schema.
  """

  def up do
    create table(:transactions) do
      add :date, :naive_datetime
      add :description, :string
      add :original_description, :string
      add :amount, :float
      add :amount_credit, :float
      add :amount_debit, :float
      add :type, :string
      add :account, references(:accounts, column: :name, type: :string)
      add :category, {:array, :string}
      add :notes, :string
      add :deleted, :boolean

      timestamps(inserted_at: :created_at)

    end
  end

  def down do
    drop table(:transactions)
  end
end
