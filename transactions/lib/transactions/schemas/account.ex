defmodule Transactions.Schemas.Account do
  @moduledoc """
    Account API Schema
  """

  use Transactions.Schema

  @primary_key {:id, :id, autogenerate: true}
  schema "accounts" do
    field :name, :string
    field :balance_start, :float
    field :deleted, :boolean

    belongs_to :account_types, Transactions.Schemas.AccountType, [foreign_key: :type, references: :name, type: :string]
    has_many :transactions, Transactions.Schemas.Transaction, foreign_key: :id

    timestamps(inserted_at: :created_at)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :name,
      :balance_start,
      :type,
      :deleted
    ])
  end
end
