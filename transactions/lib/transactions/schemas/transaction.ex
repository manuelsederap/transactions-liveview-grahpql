defmodule Transactions.Schemas.Transaction do
  @moduledoc false

  use Transactions.Schema

  @primary_key {:id, :id, autogenerate: true}
  schema "transactions" do
    field :date, :naive_datetime
    field :description, :string
    field :original_description, :string
    field :amount, :float
    field :amount_credit, :float
    field :amount_debit, :float
    field :type, :string
    field :notes, :string
    field :deleted, :boolean

    belongs_to :accounts, Transactions.Schemas.Account, [foreign_key: :account, references: :name, type: :string]
    belongs_to :transaction_categories, Transactions.Schemas.TransactionCategory, [foreign_key: :category, references: :name, type: {:array, :string}]

    timestamps(inserted_at: :created_at)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :date,
      :description,
      :original_description,
      :amount,
      :amount_credit,
      :amount_debit,
      :type,
      :account,
      :category,
      :notes,
      :deleted
    ])
  end
end
