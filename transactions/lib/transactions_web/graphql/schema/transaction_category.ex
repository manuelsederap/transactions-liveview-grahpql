defmodule TransactionsWeb.Graphql.Schema.TransactionCategory do
  @moduledoc """
    Transaction Category GraphQL schema
  """
  use Absinthe.Schema.Notation
  alias TransactionsWeb.Graphql.Resolver.TransactionCategory
  alias Transactions.Context.UtilityContext, as: UC
  
  @desc "Transaction Category"
  object :transaction_category do
    field(:id, :integer, description: "transaction category id")
    field(:name, :string, description: "Transaction Category Name")
    field(:transactions, list_of(:transaction_category_transactions), description: "List of transactions") do
      @desc "get all transactions connected on transactions category"
      resolve(UC.handle_errors(&TransactionCategory.get_transaction_category_transactions/3))
    end
    field(:deleted, :boolean, description: "Transaction category deleted status")
    field(:created_at, :string, description: "Transaction category created date")
    field(:updated_at, :string, description: "Transaction category updated date")
  end

  @desc "Transaction Category Transactions"
  object :transaction_category_transactions do
    field(:id, :string, description: "Transactions ID")
    field(:date, :string, description: "Date of Transactions")
    field(:description, :string, description: "Transaction description")
    field(:original_description, :string, description: "Transaction original description")
    field(:amount, :float, description: "Amount in transaction")
    field(:amount_credit, :float, description: "Amount credit in transaction")
    field(:amount_debit, :float, description: "Amount debit in transaction")
    field(:type, :string, description: "Transaction account type")
    field(:account, :string, description: "Transaction account name")
    field(:category, list_of(:string), description: "List of Transaction categories")
    field(:notes, :string, description: "Transaction notes")
    field(:deleted, :boolean, description: "transaction status if deleted.")
    field(:created_at, :string, description: "transaction date created")
    field(:updated_at, :string, description: "transaction date updated")
  end

  @desc "Successful Transaction Category creation"
  object :create_transaction_category do
    field :transaction_category, :transaction_category
  end

  @desc "Successful Update transaction category"
  object :update_transaction_category do
    field :message, :string, description: "Success return message"
  end

  @desc "Successful delete transaction category"
  object :delete_transaction_category do
    field :message, :string, description: "Success return message"
  end  

  @desc "Create Transaction category"
  object :transaction_category_mutations do
    field :create_transaction_category, :create_transaction_category do

      @desc "name - transaction category name"
      arg(:name, non_null(:string))

      resolve(UC.handle_errors(&TransactionCategory.create_transaction_category/3))
    end

    @desc "Update Transaction Category"
    field :update_transaction_category, :update_transaction_category do
      @desc """
        id - Account type ID
      """
      arg(:id, non_null(:string))
      @desc """
        name - Account type Name
      """
      arg(:name, non_null(:string))

      resolve(UC.handle_errors(&TransactionCategory.update_transaction_category/3))
    end

    @desc "Delete Transaction Category"
    field :delete_transaction_category, :delete_transaction_category do

      @desc "id - transaction category id"
      arg(:id, non_null(:string))

      resolve(UC.handle_errors(&TransactionCategory.delete_transaction_category/3))
    end
  end

  ### Query Transaction Category

  @desc "Transaction Category Queries"
  object :transaction_category_queries do

    @desc "transaction_categories - Return all list of transaction category"
    field :transaction_categories, list_of(:transaction_category) do
      resolve(UC.handle_errors(&TransactionCategory.get_all_of_transaction_category/3))
    end

    @desc "transaction_category - Get transaction category by id"
    field :transaction_category, :transaction_category do
      
      @desc "id - transaction category id"
      arg(:id, non_null(:string))
      
      resolve(UC.handle_errors(&TransactionCategory.get_transaction_category/3))  
    end
  end

end