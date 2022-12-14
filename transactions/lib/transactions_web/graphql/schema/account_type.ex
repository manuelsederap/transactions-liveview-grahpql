defmodule TransactionsWeb.Graphql.Schema.AccountType do
  @moduledoc """
    Account type GraphQL schema
  """

  use Absinthe.Schema.Notation
  alias TransactionsWeb.Graphql.Resolver.AccountType
  alias Transactions.Context.UtilityContext, as: UC


  @desc "Account Type"
  object :account_type do
    field(:id, :integer, description: "Account type id")
    field(:name, :string, description: "Account type Name")
    field(:transactions, list_of(:account_type_transactions), description: "List of transactions") do
      @desc "get all transcations connected on account type"
      resolve(UC.handle_errors(&AccountType.get_account_type_transactions/3))
    end
    field(:deleted, :boolean, description: "Account type status if deleted")
    field(:created_at, :string, description: "Account type date created")
    field(:updated_at, :string, description: "Account type date updated")
  end

  @desc "Account type transactions"
  object :account_type_transactions do
    field(:id, :string, description: "Transactions ID")
    field(:date, :string, description: "Date of Transactions")
    field(:description, :string, description: "Transaction description")
    field(:original_description, :string, description: "Transaction original description")
    field(:amount, :float, description: "Amount in transaction")
    field(:amount_credit, :float, description: "Amount credit in transaction")
    field(:amount_debit, :float, description: "Amount debit in transaction")
    field(:type, :string, description: "Transaction account type")
    field(:account, :string, description: "Transaction account name")
    field(:category, list_of(:string), description: "Transaction category")
    field(:notes, :string, description: "Transaction notes")
    field(:deleted, :boolean, description: "transaction status if deleted.")
    field(:created_at, :string, description: "transaction date created")
    field(:updated_at, :string, description: "transaction date updated")
  end

  @desc "Successful Account type creation"
  object :create_account_type do
    field :account_type, :account_type
  end

  @desc "Successful update Account type"
  object :update_account_type do
    field :message, :string, description: "Success return message"
  end

  @desc "Successful delete Account type"
  object :delete_account_type do
    field :message, :string, description: "Success return message"
  end

  @desc "Create account type"
  object :account_type_mutations do
    field :create_account_type, :create_account_type do
      @desc """
        name - Account type Name
      """
      arg(:name, non_null(:string))

      resolve(UC.handle_errors(&AccountType.create_account_type/3))
    end

    @desc "Update Account Type"
    field :update_account_type, :update_account_type do
      @desc """
        id - Account type ID
      """
      arg(:id, non_null(:integer))
      @desc """
        name - Account type Name
      """
      arg(:name, non_null(:string))

      resolve(UC.handle_errors(&AccountType.update_account_type/3))
    end

    @desc "Delete Account Type"
    field :delete_account_type, :delete_account_type do
      @desc """
        id - Account type ID
      """
      arg(:id, non_null(:integer))

      resolve(UC.handle_errors(&AccountType.delete_account_type/3))
    end
  end

  ### Query Account type

  @desc "Account Type Queries"
  object :account_type_queries do
    @desc """
      account types = Return list of account type
    """ 
    field :account_types, list_of(:account_type) do
      resolve(UC.handle_errors(&AccountType.get_all_of_account_types/3))
    end

    @desc "Get account type by ID parameter"
    field :account_type, :account_type do
      @desc """
        id - Account type ID
      """
      arg(:id, non_null(:integer))

      resolve(UC.handle_errors(&AccountType.get_account_type/3))  
    end
  end
end
