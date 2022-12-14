defmodule Transactions.Schemas.AccountType do
  @moduledoc """
    Account Type API schema.
  """

  use Transactions.Schema

  @primary_key {:id, :id, autogenerate: true}
  schema "account_types" do
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
