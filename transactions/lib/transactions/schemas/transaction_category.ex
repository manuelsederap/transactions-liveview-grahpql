defmodule Transactions.Schemas.TransactionCategory do
  @moduledoc """
    Transcation Category API Schema
  """

  use Transactions.Schema

  @primary_key {:id, :id, autogenerate: true}
  schema "transaction_categories" do
    field :name, :string
    field :deleted, :boolean

    has_many :transactions, Transactions.Schemas.Transaction, foreign_key: :id
    
    timestamps(inserted_at: :created_at)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :name,
      :deleted
    ])
  end
end
