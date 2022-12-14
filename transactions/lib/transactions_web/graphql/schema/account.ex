defmodule TransactionsWeb.Graphql.Schema.Account do
  @moduledoc """
    Account GraphQL schema
  """
  use Absinthe.Schema.Notation
  alias TransactionsWeb.Graphql.Resolver.Account
  alias Transactions.Context.UtilityContext, as: UC

  @desc "Account"
  object :account do
    field(:id, :integer, description: "Account id PK")
    field(:name, :string, description: "Account Name")
    field(:balance_start, :float, description: "Account Balance Start")
    field(:type, :string, description: "Account Type")
    field(:transactions, list_of(:account_transactions), description: "List of transactions") do
      @desc "get all transactions connected on account"
      resolve(UC.handle_errors(&Account.get_account_transactions/3))
    end
    field(:deleted, :boolean, description: "Account status if deleted")
    field(:created_at, :string, description: "Account date created")
    field(:updated_at, :string, description: "Account date updated")
  end

  @desc "Account transactions"
  object :account_transactions do
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

  @desc "Successful Account creation"
  object :create_account do
    field :account, :account
  end

  @desc "Successful Update Account"
  object :update_account do
    field :message, :string, description: "Success return message"
  end

  @desc "Successful delete Account"
  object :delete_account do
    field :message, :string, description: "Success return message"
  end  

  @desc "Account Mutations"
  object :account_mutations do
    field :create_account, :create_account do
      
      @desc "name - Account Name"
      arg(:name, non_null(:string))

      @desc "balance_start - Account balance start"
      arg(:balance_start, non_null(:float))

      @desc "type - Account Type"
      arg(:type, non_null(:string))

      resolve(UC.handle_errors(&Account.create_account/3))
    end

    field :update_account, :update_account do
      @desc "id - Account ID Unique"
      arg(:id, non_null(:string))

      @desc "name - Account Name"
      arg(:name, non_null(:string))

      @desc "type - Account Type"
      arg(:type, non_null(:string))

      @desc "balance_start - Account balance start"
      arg(:balance_start, non_null(:string))

      resolve(UC.handle_errors(&Account.update_account/3))
    end

    field :delete_account, :delete_account do
      @desc "id - Account ID Unique"
      arg(:id, non_null(:string))

      resolve(UC.handle_errors(&Account.delete_account/3))
    end
  end

  ### Query Account

  @desc "Account Queries"
  object :account_queries do
    @desc "accounts - Return list of accounts"
    field :accounts, list_of(:account) do
      resolve(UC.handle_errors(&Account.get_all_of_accounts/3))
    end

    @desc "account - Get account by id"
    field :account, :account do
      @desc "id - Account ID Unique"
      arg(:id, non_null(:string))

      resolve(UC.handle_errors(&Account.get_account/3))
    end
  end

end