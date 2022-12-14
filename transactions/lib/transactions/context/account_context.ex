defmodule Transactions.Context.AccountContext do
  @moduledoc """
    Account context, related in business logic functions
  """

  import Ecto.{Query}, warn: false
  alias Ecto.Changeset
  alias Transactions.{
    Repo,
    Schemas.Account,
    Schemas.AccountType,
    Schemas.Transaction
  }


  # params validator for create account
  def validate_params(:create_account, params) do
    fields = %{
      name: :string,
      type: :string,
      balance_start: :float
    }

    {%{}, fields}
    |> Changeset.cast(params, Map.keys(fields))
    |> Changeset.validate_required([:name], message: "Enter name")
    |> Changeset.validate_required([:type], message: "Enter Type")
    |> Changeset.validate_required([:balance_start], message: "Enter balance start")
    |> validate_name_already_exist()
    |> validate_account_type()
    |> is_valid_changeset?()
  end

  #params validator for update account
  def validate_params(:update_account, params) do
    fields = %{
      id: :string,
      name: :string,
      type: :string,
      balance_start: :string
    }

    {%{}, fields}
    |> Changeset.cast(params, Map.keys(fields))
    |> Changeset.validate_required([:id], message: "Enter id")
    |> Changeset.validate_required([:name], message: "Enter name")
    |> Changeset.validate_required([:type], message: "Enter type")
    |> Changeset.validate_required([:balance_start], message: "Enter balance start")
    |> validate_name_already_exist()
    |> validate_account_exist()
    |> validate_account_type()
    |> is_valid_changeset?()
  end

  #params validator for delete account
  def validate_params(:delete_account, params) do
    field = %{
      id: :string
    }

    {%{}, field}
    |> Changeset.cast(params, Map.keys(field))
    |> Changeset.validate_required([:id], message: "Enter id")
    |> validate_account_exist()
    |> validate_transaction_in_account()
    |> is_valid_changeset?()
  end

  #params validator for get account
  def validate_params(:get_account, params) do
    field = %{
      id: :string
    }

    {%{}, field}
    |> Changeset.cast(params, Map.keys(field))
    |> Changeset.validate_required([:id], message: "Enter id")
    |> validate_account_exist()
    |> is_valid_changeset?()
  end

  #check if it has transaction connected in account return 0 or 1
  def validate_transaction_in_account(%{changes: %{id: id},
    valid?: true} = changeset) do

    Account
    |> join(:inner, [a], t in Transaction, on: a.name == t.account)
    |> where([a, t], a.id == ^id)
    |> select([a, t], count(t.id))
    |> limit(1)
    |> Repo.one()
    |> validate_transaction_in_account(changeset)
  end

  def validate_transaction_in_account(changeset), do: changeset

  # if validate_transaction_in_account return 1 it has
  # atleast 1 transaction connected to it, add error
  def validate_transaction_in_account(1, changeset), do:
    Changeset.add_error(changeset, :id, "Account can't be deleted. It has transaction that exist.")

  # else if no transaction exist, that connected in accout, good to go.
  def validate_transaction_in_account(_, changeset), do: changeset

  # check if account exist, return 0/1
  def validate_account_exist(%{changes: %{id: id}, 
    valid?: true} = changeset) do
  
    Account
    |> where([a], a.id == ^id)
    |> select([a], count(a.id))
    |> limit(1)
    |> Repo.one()
    |> validate_account_exist(changeset)
  end
  def validate_account_exist(changeset), do: changeset

  # if 1, account is exist, continue, changeset valid true
  def validate_account_exist(1, changeset), do: changeset

  # if 0, accout is not exist, add error message, changeset valid false
  def validate_account_exist(0, changeset), do:
    Changeset.add_error(changeset, :id, "Account does not exist.")

  # check if account type name is exist return 0/1
  def validate_account_type(%{changes: %{type: type},
    valid?: true} = changeset) do

    AccountType
    |> where([at], at.name == ^type)
    |> select([at], count(at.name))
    |> limit(1)
    |> Repo.one()
    |> validate_account_type(changeset)
  end
  def validate_account_type(changeset), do: changeset

  # check if account type exist, if not error return
  def validate_account_type(0, changeset), do:
    Changeset.add_error(changeset, :type, "Account Type not Exist.")

  # check if account type exist and can create account with that type
  def validate_account_type(_, changeset), do: changeset

  #validate if account is already have account type name (return 1/0)
  def validate_name_already_exist(%{changes: %{name: name}} = changeset) do
    Account
    |> where([at], at.name == ^name)
    |> select([at], count(at.name))
    |> limit(1)
    |> Repo.one()
    |> validate_name_already_exist(changeset)
  end
  def validate_name_already_exist(changeset), do: changeset

  # if 0 name still available continue valid true
  def validate_name_already_exist(0, changeset), do: changeset

  # if _ name already exist return error message
  def validate_name_already_exist(_, changeset), do:
    Changeset.add_error(changeset, :id, "Account Name is already exist.")

  # catcher if create account changeset has error, cant create the account
  def create_account({:error, changeset}), do: {:error, changeset}
  def create_account(params) do
    account =
      %Account{}
      |> Account.changeset(
        Map.put(params, :deleted, false)
      )
      |> Repo.insert!()

    %{account: account}
  end

  # catcher if update account changeset has error, cant update the account
  def update_account({:error, changeset}), do: {:error, changeset}
  def update_account(params) do
    {val, _} = Float.parse(params.balance_start)
    params =
      params
      |> Map.replace(:balance_start, val)

    account = get_account_by_id(params.id)
    update_account(params, account)
  end

  def update_account(params, account) do
    account
    |> Account.changeset(params)
    |> Repo.update()
    |> result_checker(:update)
  end

  # catcher if delete account changeset has error, cant delete the account
  def delete_account({:error, changeset}), do: {:error, changeset}
  def delete_account(params) do
    account = get_account_by_id(params.id)
    delete_account(account, %{deleted: true})
  end

  def delete_account(account, params) do
    account
    |> Account.changeset(params)
    |> Repo.update()
    |> result_checker(:delete)
  end

  # catcher if get account changeset has error, cant get the account
  def get_account({:error, changeset}), do: {:error, changeset}
  def get_account(params), do: get_account_by_id(params.id)

  # return all list of accounts
  def get_all_of_accounts(), do: Account |> Repo.all()

  def get_account_by_id(id), do: Account |> Repo.get_by(%{id: id})

  # get all transactions connected in account
  def get_account_transactions(account_name) do
    Transaction
    |> join(:inner, [t], a in Account, on: t.account == a.name)
    |> where([t, a], a.name == ^account_name)
    |> select([t, a], %{
      id: t.id,
      date: t.date,
      description: t.description,
      original_description: t.original_description,
      amount: t.amount,
      amount_credit: t.amount_credit,
      amount_debit: t.amount_debit,
      type: t.type,
      account: t.account,
      category: t.category,
      notes: t.notes,
      deleted: t.deleted,
      created_at: t.created_at,
      updated_at: t.updated_at      
    })
    |> Repo.all()
  end

  # Check result of Repo, if return ok, return Success message 
  def result_checker({:ok, _}, :update), do: %{message: "Successfully Updated"}

  # Check result of Repo, if return not ok, return Error message 
  def result_checker({_, _}, :update), do: %{message: "Error Updating.."}

  # Check result of Repo, if return ok, return Success message 
  def result_checker({:ok, _}, :delete), do: %{message: "Successfully Deleted"}

    # Check result of Repo, if return not ok, return Error message 
  def result_checker({_, _}, :delete), do: %{message: "Error Deleting.."}

  def is_valid_changeset?(changeset), do: {changeset.valid?, changeset}
end