defmodule TransactionsWeb.Graphql.Resolver.Account do
  @moduledoc """
    Account GraphQL Resolver (this is similar in elixir controller)
  """

  @type resolver_output :: ok_output | error_output | plugin_output
  @type ok_output :: {:ok, any}
  @type error_output :: {:error, binary}
  @type plugin_output :: {:plugin, Absinthe.Plugin.t(), term}

  alias Transactions.Context.AccountContext, as: AC
  alias Transactions.Context.ValidationContext, as: VC

  def create_account(_, params, _) do
    :create_account
    |> AC.validate_params(params)
    |> VC.valid_changeset()
    |> AC.create_account()
    |> return_result()
  end

  def update_account(_, params, _) do
    :update_account
    |> AC.validate_params(params)
    |> VC.valid_changeset()
    |> AC.update_account()
    |> return_result()
  end

  def delete_account(_, params, _) do
    :delete_account
    |> AC.validate_params(params)
    |> VC.valid_changeset()
    |> AC.delete_account()
    |> return_result()
  end

  def get_all_of_accounts(_, _params, _) do
    AC.get_all_of_accounts()
    |> return_result()
  end

  def get_account(_, params, _) do
    :get_account
    |> AC.validate_params(params)
    |> VC.valid_changeset()
    |> AC.get_account()
    |> return_result()
  end

  def get_account_transactions(%{name: name}, _params, _) do
    AC.get_account_transactions(name)
    |> return_result()
  end

  defp return_result({:error, changeset}), do: {:error, changeset}
  defp return_result(result), do: {:ok, result}  
end