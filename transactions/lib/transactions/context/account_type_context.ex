defmodule Transactions.Context.AccountTypeContext do
  @moduledoc """
    Account type context, related in business logic functions
  """

  import Ecto.{Query}, warn: false
  alias Ecto.Changeset
  alias Transactions.{
    Repo,
    Schemas.AccountType,
    Schemas.Account,
    Schemas.Transaction
  }

  # params validator for create account type
  def validate_params(:create_account_type, params) do
    field = %{
      name: :string
    }

    {%{}, field}
    |> Changeset.cast(params, Map.keys(field))
    |> Changeset.validate_required([:name], message: "Enter name")
    |> validate_name_already_exist()
    |> is_valid_changeset?()
  end

  # params validator for update account type
  def validate_params(:update_account_type, params) do
    fields = %{
      id: :integer,
      name: :string
    }

    {%{}, fields}
    |> Changeset.cast(params, Map.keys(fields))
    |> Changeset.validate_required([:id, :name])
    |> validate_name_already_exist()
    |> validate_account_type_id_exist?()
    |> validate_account_type_is_deleted?()
    |> is_valid_changeset?()
  end

  # params validator for delete account type
  def validate_params(:delete_account_type, params) do
    field = %{
      id: :integer
    }

    {%{}, field}
    |> Changeset.cast(params, Map.keys(field))
    |> Changeset.validate_required([:id], message: "Enter id")
    |> validate_account_type_id_exist?()
    |> validate_account_type_is_deleted?()
    |> is_valid_changeset?()
  end

  #params validator for get account type
  def validate_params(:get_account_type, params) do
    field = %{
      id: :integer
    }

    {%{}, field}
    |> Changeset.cast(params, Map.keys(field))
    |> Changeset.validate_required([:id], message: "Enter id")
    |> validate_account_type_id_exist?()
    |> is_valid_changeset?()
  end

  # catch creating account type, if changeset is error, will not create account type
  def create_account_type({:error, changeset}), do: {:error, changeset}
  def create_account_type(params) do
    account_type =
      %AccountType{}
      |> AccountType.changeset(
        Map.put(params, :deleted, false)
      )
      |> Repo.insert!()
    
    %{account_type: account_type}
  end
  
  # catch updating account type,  if changeset is error, will not update account type
  def update_account_type({:error, changeset}), do: {:error, changeset}
  def update_account_type(params) do
    account_type = get_account_type_by_id(params.id)
    account_type
    |> AccountType.changeset(%{name: params.name})
    |> Repo.update()
    |> result_checker(:update)
  end

  # catch delete account type,  if changeset is error, will not delete account type
  def delete_account_type({:error, changeset}), do: {:error, changeset}
  def delete_account_type(params) do
    account_type = get_account_type_by_id(params.id)
    account_type
    |> AccountType.changeset(%{deleted: true})
    |> Repo.update()
    |> result_checker(:delete)
  end

  # return all list of account types
  def get_all_of_account_types(), do: AccountType |> Repo.all()

  # catch get account type,  if changeset is error, will not get account type
  def get_account_type({:error, changeset}), do: {:error, changeset}
  def get_account_type(params), do: get_account_type_by_id(params.id)

  # get all transactions connected in account type
  def get_account_type_transactions(account_type_name) do
    Transaction
    |> join(:inner, [t], a in Account, on: t.account == a.name)
    |> join(:inner, [t, a], at in AccountType, on: a.type == at.name)
    |> where([t, a, at], at.name == ^account_type_name)
    |> select([t, a, at], %{
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

  #validate if account type is already have account type name (return 1/0)
  def validate_name_already_exist(%{changes: %{name: name}} = changeset) do
    AccountType
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
    Changeset.add_error(changeset, :id, "Account Type Name is already exist.")

  # Validate if account type is already deleted (this function will return true/false)
  def validate_account_type_is_deleted?(%{changes: %{id: id},
      valid?: true} = changeset) do
    AccountType
    |> where([at], at.id == ^id)
    |> select([at], at.deleted)
    |> Repo.one()
    |> validate_account_type_is_deleted?(changeset)
  end
  def validate_account_type_is_deleted?(changeset), do: changeset

  # Check if already deleted then return error message
  def validate_account_type_is_deleted?(true, changeset), do:
    Changeset.add_error(changeset, :id, "Account Type is already Deleted.")

  # if deleted are not true then you can update/delete the data.
  def validate_account_type_is_deleted?(_, changeset), do: changeset

  # validate account type id if exists (this function will return 1/0)
  def validate_account_type_id_exist?(%{changes: %{id: id},
      valid?: true} = changeset) do
    AccountType
    |> where([at], at.id == ^id)
    |> select([at], count(at.id))
    |> limit(1)
    |> Repo.one()
    |> validate_account_type_id_exist?(changeset)
  end
  def validate_account_type_id_exist?(changeset), do: changeset

  # if account type id count as 0, then error message will return.
  def validate_account_type_id_exist?(0, changeset), do:
    Changeset.add_error(changeset, :id, "Account Type ID does not exist")

  # if account type return 1 will continue to changeset valid true
  def validate_account_type_id_exist?(_, changeset), do: changeset

  # Get account type by id, Return 1 data.
  def get_account_type_by_id(id), do: AccountType |> Repo.get_by(%{id: id})

  # Changeset checker, if changeset valid is true or false
  def is_valid_changeset?(changeset), do: {changeset.valid?, changeset}
end
