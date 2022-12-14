defmodule TransactionsWeb.Graphql.Schema.Transaction do
  @moduledoc """
    Transaction GraphQL schema
  """

  use Absinthe.Schema.Notation
  alias TransactionsWeb.Graphql.Resolver.Transaction
  alias Transactions.Context.UtilityContext, as: UC

  @desc "Transaction"
  object :transaction do
    field(:id, :string, description: "Transactions ID")
    field(:date, :string, description: "Date of Transactions")
    field(:description, :string, description: "Transaction description")
    field(:original_description, :string, description: "Transaction original description")
    field(:amount, :float, description: "Amount in transaction")
    field(:amount_credit, :float, description: "Amount credit in transaction")
    field(:amount_debit, :float, description: "Amount debit in transaction")
    field(:type, :string, description: "Transaction account type")
    field(:account, :string, description: "Transaction account name")
    field(:category, list_of(:string), description: "Transaction categories")
    field(:notes, :string, description: "Transaction notes")
    field(:deleted, :boolean, description: "transaction status if deleted.")
    field(:created_at, :string, description: "transaction date created")
    field(:updated_at, :string, description: "transaction date updated")  
  end

  @desc "Successful transaction creation"
  object :create_transaction do
    field :transaction, :transaction
  end

  @desc "Successful Update Transaction"
  object :update_transaction do
    field :message, :string, description: "Success return message"
  end

  @desc "Successful Delete Transaction"
  object :delete_transaction do
    field :message, :string, description: "Success return message"
  end

  @desc "Successful Update Transaction add Categories"
  object :update_transaction_add_categories do
    field :message, :string, description: "Success return message"
  end

  @desc "Successful Update Transaction Remove Categories"
  object :update_transaction_remove_categories do
    field :message, :string, description: "Success return message"
  end

  @desc "Transaction Mutations"
  object :transaction_mutations do
    
    @desc "create transaction"
    field :create_transaction, :create_transaction do
      @desc "date - Date of Transaction"
      arg(:date, non_null(:string))

      @desc "description - Transaction Description"
      arg(:description, :string)

      @desc "original_description - Transaction Original Description"
      arg(:original_description, non_null(:string))

      @desc "amount - Amount in transaction"
      arg(:amount, non_null(:string))

      @desc "amont_credit - Amount credit in transaction"
      arg(:amount_credit, :string)

      @desc "amout_debit - Amount debit in transaction"
      arg(:amount_debit, :string)

      @desc "type - Type of transaction"
      arg(:type, non_null(:string))

      @desc "account - Transaction account name"
      arg(:account, non_null(:string))

      @desc "category - Transaction category name"
      arg(:category, list_of(:string))

      @desc "notes - Transaction notes"
      arg(:notes, :string)

      resolve(UC.handle_errors(&Transaction.create_transaction/3))
    end

    @desc "update transaction"
    field :update_transaction, :update_transaction do

      @desc "id - Transaction id, Unique key"
      arg(:id, non_null(:string))

      @desc "date - Date of Transaction"
      arg(:date, non_null(:string))

      @desc "description - Transaction Description"
      arg(:description, :string)

      @desc "original_description - Transaction Original Description"
      arg(:original_description, non_null(:string))

      @desc "amount - Amount in transaction"
      arg(:amount, non_null(:string))

      @desc "amont_credit - Amount credit in transaction"
      arg(:amount_credit, :string)

      @desc "amout_debit - Amount debit in transaction"
      arg(:amount_debit, :string)

      @desc "type - Type of transaction"
      arg(:type, non_null(:string))

      @desc "account - Transaction account name"
      arg(:account, non_null(:string))

      @desc "category - Transaction category name"
      arg(:category, list_of(:string))

      @desc "notes - Transaction notes"
      arg(:notes, :string)

      resolve(UC.handle_errors(&Transaction.update_transaction/3))    
    end

    @desc "Delete Transaction"
    field :delete_transaction, :delete_transaction do
      
      @desc "id - Transaction ID unique key"
      arg(:id, non_null(:string))

      resolve(UC.handle_errors(&Transaction.delete_transaction/3))
    end

    @desc "Update Transaction Add Categories"
    field :update_transaction_add_categories, :update_transaction_add_categories do

      @desc "id - Transaction ID unique key"
      arg(:id, non_null(:integer))

      @desc "List ID of Transaction Categories"
      arg(:category, non_null(list_of(:integer)))

      resolve(UC.handle_errors(&Transaction.update_transaction_add_categories/3))
    end

    @desc "Update Transaction Remove Categories"
    field :update_transaction_remove_categories, :update_transaction_remove_categories do
      
      @desc "id - Transaction ID unique key"
      arg(:id, non_null(:integer))

      @desc "List ID of Transaction Categories"
      arg(:category, list_of(:string))

      resolve(UC.handle_errors(&Transaction.update_transaction_remove_categories/3))
    end
  end

  ### Query Transaction

  @desc "Transaction Queries"
  object :transaction_queries do
    @desc "transactions - Return list of transactions"
    field :transactions, list_of(:transaction) do
      resolve(UC.handle_errors(&Transaction.get_all_of_transactions/3))
    end

    @desc "transaction - Get transaction by id"
    field :transaction, :transaction do
      
      @desc "id - Transaction ID - Unique key"
      arg(:id, non_null(:string))

      resolve(UC.handle_errors(&Transaction.get_transaction/3))
    end
  end
end