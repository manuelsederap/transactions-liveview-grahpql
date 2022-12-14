defmodule Transactions.Context.TransactionCategoryContext do
  @moduledoc """
    transaction category context, related in business logic functions
  """

  import Ecto.{Query}, warn: false
  alias Ecto.Changeset
  alias Transactions.{
    Repo,
    Schemas.Transaction,
    Schemas.TransactionCategory
  }

  #params validator for create transaction category
  def validate_params(:create_transaction_category, params) do
    field = %{
      name: :string
    }

    {%{}, field}
    |> Changeset.cast(params, Map.keys(field))
    |> Changeset.validate_required([:name], message: "Enter name")
    |> validate_name_already_exist()
    |> is_valid_changeset?()
  end

  #params validator for update transaction category
  def validate_params(:update_transaction_category, params) do
    fields = %{
      id: :string,
      name: :string
    }

    {%{}, fields}
    |> Changeset.cast(params, Map.keys(fields))
    |> Changeset.validate_required([:id], message: "Enter id")
    |> Changeset.validate_required([:name], message: "Enter name")
    |> validate_name_already_exist()
    |> validate_transaction_category_id_exist?()
    |> validate_transaction_category_is_deleted?()
    |> is_valid_changeset?()
  end

  #params validator for delete transaction category
  def validate_params(:delete_transaction_category, params) do
    field = %{
      id: :string
    }

    {%{}, field}
    |> Changeset.cast(params, Map.keys(field))
    |> Changeset.validate_required([:id], message: "Enter id")
    |> validate_transaction_category_id_exist?()
    |> validate_transaction_category_is_deleted?()
    |> is_valid_changeset?()
  end

  #params validator for delete transaction category
  def validate_params(:get_transaction_category, params) do
    field = %{
      id: :string
    }

    {%{}, field}
    |> Changeset.cast(params, Map.keys(field))
    |> Changeset.validate_required([:id], message: "Enter id")
    |> validate_transaction_category_id_exist?()
    |> is_valid_changeset?()
  end

  #validate if transaction category is already have account type name (return 1/0)
  def validate_name_already_exist(%{changes: %{name: name}} = changeset) do
    TransactionCategory
    |> where([tc], tc.name == ^name)
    |> select([tc], count(tc.name))
    |> limit(1)
    |> Repo.one()
    |> validate_name_already_exist(changeset)
  end
  def validate_name_already_exist(changeset), do: changeset

  # if 0 name still available continue valid true
  def validate_name_already_exist(0, changeset), do: changeset

  # if _ name already exist return error message
  def validate_name_already_exist(_, changeset), do:
    Changeset.add_error(changeset, :id, "Transaction Category Name is already exist.")

  # validate account type id if exists (this function will return 1/0)
  def validate_transaction_category_id_exist?(%{changes: %{id: id},
      valid?: true} = changeset) do
    TransactionCategory
    |> where([tc], tc.id == ^id)
    |> select([tc], count(tc.id))
    |> limit(1)
    |> Repo.one()
    |> validate_transaction_category_id_exist?(changeset)
  end
  def validate_transaction_category_id_exist?(changeset), do: changeset

  # if account type id count as 0, then error message will return.
  def validate_transaction_category_id_exist?(0, changeset), do:
    Changeset.add_error(changeset, :id, "Transaction Category ID does not exist")

  # if account type return 1 will continue to changeset valid true
  def validate_transaction_category_id_exist?(_, changeset), do: changeset

  # Validate if account type is already deleted (this function will return true/false)
  def validate_transaction_category_is_deleted?(%{changes: %{id: id}, valid?: true} = changeset) do
    TransactionCategory
    |> where([tc], tc.id == ^id)
    |> select([tc], tc.deleted)
    |> Repo.one()
    |> validate_transaction_category_is_deleted?(changeset)
  end
  def validate_transaction_category_is_deleted?(changeset), do: changeset

  # Check if already deleted then return error message
  def validate_transaction_category_is_deleted?(true, changeset), do:
    Changeset.add_error(changeset, :id, "Transaction category is already Deleted.")

  # if deleted are not true then you can update/delete the data.
  def validate_transaction_category_is_deleted?(_, changeset), do: changeset  

  # catch creating transaction category, if changeset is error, will not create transaction category
  def create_transaction_category({:error, changeset}), do: {:error, changeset}
  def create_transaction_category(params) do
    transaction_category =
      %TransactionCategory{}
      |> TransactionCategory.changeset(
        Map.put(params, :deleted, false)
      )
      |> Repo.insert!()

    %{transaction_category: transaction_category}
  end

  # catch updating transaction category, if changeset is error, will not update transaction category
  def update_transaction_category({:error, changeset}), do: {:error, changeset}
  def update_transaction_category(params) do
    transaction_category = get_transaction_category_by_id(params.id)
    update_transaction_category(transaction_category, %{name: params.name})
  end

  def update_transaction_category(tc, params) do
    tc
    |> TransactionCategory.changeset(params)
    |> Repo.update()
    |> result_checker(:update)
  end

  # catch deleting transaction category, if changeset is error, will not delete transaction category
  def delete_transaction_category({:error, changeset}), do: {:error, changeset}
  def delete_transaction_category(params) do
    transaction_category = get_transaction_category_by_id(params.id)
    delete_transaction_category(transaction_category, %{deleted: true})
  end

  def delete_transaction_category(tc, params) do
    tc
    |> TransactionCategory.changeset(params)
    |> Repo.update()
    |> result_checker(:delete)
  end

  #return all list of transaction category
  def get_all_of_transaction_category(), do: TransactionCategory |> Repo.all()

  # catch getting transaction category, if changeset is error, will not get transaction category
  def get_transaction_category({:error, changeset}), do: {:error, changeset}
  def get_transaction_category(params), do: get_transaction_category_by_id(params.id)

  # get all transactions in transaction category
  def get_transaction_category_transactions(tc_name) do
    Transaction
    |> join(:inner, [t], tc in TransactionCategory, on: tc.name in t.category)
    |> where([t, tc], tc.name == ^tc_name)
    |> select([t, tc], %{
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

  def get_transaction_category_by_id(id), do: TransactionCategory |> Repo.get_by(%{id: id})

  def is_valid_changeset?(changeset), do: {changeset.valid?, changeset}


  ################ LIVE VIEW REPO FUNCTION ###########################

  def list_transaction_categories do
    TransactionCategory
    |> order_by([tcc], asc: tcc.created_at)
    |> Repo.all()
  end  
end