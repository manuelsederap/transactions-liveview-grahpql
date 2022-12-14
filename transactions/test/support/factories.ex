defmodule Transactions.Factory do
  @moduledoc "All mock data used for testing are defined here"
  use ExMachina.Ecto, repo: Transactions.Repo

  alias Transactions.Schemas.{
    Account,
    AccountType,
    Transaction,
    TransactionCategory
  }

  def account_type_factory, do: %AccountType{}
  def account_factory, do: %Account{}
  def transaction_category_factory, do: %TransactionCategory{}
  def transaction_factory, do: %Transaction{}

end
