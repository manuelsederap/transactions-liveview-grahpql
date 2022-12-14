defmodule TransactionsWeb.Graphql.Resolver.Transaction do
  @moduledoc """
    Transaction GraphQL Resolver (this is similar in elixir controller)
  """

  @type resolver_output :: ok_output | error_output | plugin_output
  @type ok_output :: {:ok, any}
  @type error_output :: {:error, binary}
  @type plugin_output :: {:plugin, Absinthe.Plugin.t(), term}

  alias Transactions.Context.TransactionContext, as: TC
  alias Transactions.Context.ValidationContext, as: VC

  def create_transaction(_, params, _) do
    :create_transaction
    |> TC.validate_params(params)
    |> VC.valid_changeset()
    |> TC.create_transaction()
    |> return_result()
  end

  def update_transaction(_, params, _) do
    :update_transaction
    |> TC.validate_params(params)
    |> VC.valid_changeset()
    |> TC.update_transaction()
    |> return_result()
  end

  def delete_transaction(_, params, _) do
    :delete_transaction
    |> TC.validate_params(params)
    |> VC.valid_changeset()
    |> TC.delete_transaction()
    |> return_result()
  end

  def get_all_of_transactions(_, _params, _) do
    TC.get_all_of_transactions()
    |> return_result()
  end

  def get_transaction(_, params, _) do
    :get_transaction
    |> TC.validate_params(params)
    |> VC.valid_changeset()
    |> TC.get_transaction()
    |> return_result()
  end

  def update_transaction_add_categories(_,params, _) do
    :update_transaction_add_categories
    |> TC.validate_params(params)
    |> VC.valid_changeset()
    |> TC.update_transaction_add_categories()
    |> return_result()
  end

  def update_transaction_remove_categories(_, params, _) do
    :update_transaction_remove_categories
    |> TC.validate_params(params)
    |> VC.valid_changeset()
    |> TC.update_transaction_remove_categories()
    |> return_result()
  end

  defp return_result({:error, changeset}), do: {:error, changeset}
  defp return_result(result), do: {:ok, result}   
end