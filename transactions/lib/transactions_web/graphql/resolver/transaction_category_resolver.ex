defmodule TransactionsWeb.Graphql.Resolver.TransactionCategory do
  @moduledoc """
    Transaction Category GraphQL Resolver (this is similar in elixir controller)
  """

  @type resolver_output :: ok_output | error_output | plugin_output
  @type ok_output :: {:ok, any}
  @type error_output :: {:error, binary}
  @type plugin_output :: {:plugin, Absinthe.Plugin.t(), term}

  alias Transactions.Context.TransactionCategoryContext, as: TCC
  alias Transactions.Context.ValidationContext, as: VC

  # function that create transaction category data
  def create_transaction_category(_, params, _) do
    :create_transaction_category
    |> TCC.validate_params(params) # create params validator function
    |> VC.valid_changeset() # changeset checker function return params/{:error, changeset}
    |> TCC.create_transaction_category() # create function, if all params is valid.
    |> return_result() # result checker function if error/valid
  end

  # function that update transaction category data
  def update_transaction_category(_, params, _) do
    :update_transaction_category
    |> TCC.validate_params(params) # update params validator function
    |> VC.valid_changeset() # changeset checker function return params/{:error, changeset}
    |> TCC.update_transaction_category() # update function, if all params is valid.
    |> return_result() # result checker function if error/valid
  end

  # function that delete transaction category data
  def delete_transaction_category(_, params, _) do
    :delete_transaction_category
    |> TCC.validate_params(params) # delete params validator function
    |> VC.valid_changeset() # changeset checker function return params/{:error, changeset}
    |> TCC.delete_transaction_category() # delete function, if all params is valid.
    |> return_result() # result checker function if error/valid
  end

  # function that get all list of transaction category
  def get_all_of_transaction_category(_, _params, _) do
    TCC.get_all_of_transaction_category() # return list of data
    |> return_result() # result checker function if error/valid
  end

  # function that delete per  transaction category data
  def get_transaction_category(_, params, _) do
    :get_transaction_category
    |> TCC.validate_params(params) # get params validator function
    |> VC.valid_changeset() # changeset checker function return params/{:error, changeset}
    |> TCC.get_transaction_category() # get function, if all params is valid.
    |> return_result() # result checker function if error/valid
  end

  # function that get all transactions associate in transaction category
  def get_transaction_category_transactions(%{name: name}, _params, _) do
    TCC.get_transaction_category_transactions(name) # return list of transactions
    |> return_result() # result checker function if error/valid
  end

  # result checker for error return
  defp return_result({:error, changeset}), do: {:error, changeset}

  # result checker for valid return
  defp return_result(result), do: {:ok, result}  
end