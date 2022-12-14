defmodule Transactions.Context.TransactionContext do
  @moduledoc """
    Transaction context, related in business logic functions
  """

  import Ecto.{Query}, warn: false
  alias Ecto.Changeset
  alias Transactions.Context.UtilityContext, as: UC
  alias Transactions.{
    Repo,
    Schemas.Account,
    Schemas.AccountType,
    Schemas.TransactionCategory,
    Schemas.Transaction
  }

  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(Transactions.PubSub, @topic)
  end

  defp broadcast_change({:ok, result}, event) do
    Phoenix.PubSub.broadcast(
      Transactions.PubSub,
      @topic,
      {__MODULE__, event, result})
  end
  
  #params validator for create transaction
  def validate_params(:create_transaction, params) do
    fields = %{
      date: :string,
      description: :string,
      original_description: :string,
      amount: :string,
      amount_debit: :string,
      amount_credit: :string,
      type: :string,
      account: :string,
      category: {:array, :string},
      notes: :string
    }

    {%{}, fields}
    |> Changeset.cast(params, Map.keys(fields))
    |> Changeset.validate_required([:date], message: "Enter date")
    |> Changeset.validate_required([:original_description], message: "Enter Original Description")
    |> Changeset.validate_required([:amount], message: "Enter amount")
    |> Changeset.validate_required([:type], message: "Enter type")
    |> Changeset.validate_required([:account], message: "Enter account")
    |> Changeset.validate_inclusion(:type, [
      "credit",
      "debit"
      ], message: "Type is Invalid. Allowed values: credit and debit")
    |> Changeset.validate_format(:date,
      ~r/^(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)[\/\-](0[1-9]|[12][0-9]|3[01])[\/\-]\d{4}$/, message: "date must be in MMM-DD-YYYY format")      
    |> validate_account_name_exist()
    |> validate_category_if_not_exist_create()
    |> validate_debit_credit()
    |> is_valid_changeset?()
  end

  #params validator for create transaction
  def validate_params(:update_transaction, params) do
      fields = %{
      id: :string,
      date: :string,
      description: :string,
      original_description: :string,
      amount: :string,
      amount_debit: :string,
      amount_credit: :string,
      type: :string,
      account: :string,
      category: {:array, :string},
      notes: :string
    }

    {%{}, fields}
    |> Changeset.cast(params, Map.keys(fields))
    |> Changeset.validate_required([:id], message: "Enter id")
    |> Changeset.validate_required([:date], message: "Enter date")
    |> Changeset.validate_required([:original_description], message: "Enter Original Description")
    |> Changeset.validate_required([:amount], message: "Enter amount")
    |> Changeset.validate_required([:type], message: "Enter type")
    |> Changeset.validate_required([:account], message: "Enter account")
    |> Changeset.validate_required([:category], message: "Enter category")
    |> Changeset.validate_inclusion(:type, [
      "credit",
      "debit"
      ], message: "Type is Invalid. Allowed values: credit and debit")
    |> Changeset.validate_format(:date,
      ~r/^(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)[\/\-](0[1-9]|[12][0-9]|3[01])[\/\-]\d{4}$/, message: "date must be in MMM-DD-YYYY format")
    |> validate_category()
    |> validate_transaction_exist()
    |> validate_account_name_exist()
    |> validate_transaction_category()
    |> validate_debit_credit()
    |> is_valid_changeset?()
  end

  #params validator for delete transaction
  def validate_params(:delete_transaction, params) do
    field = %{
      id: :string
    }

    {%{}, field}
    |> Changeset.cast(params, Map.keys(field))
    |> Changeset.validate_required([:id], message: "Enter id")
    |> validate_transaction_exist()
    |> is_valid_changeset?()
  end

  #params validator for delete transaction
  def validate_params(:get_transaction, params) do
    field = %{
      id: :string
    }

    {%{}, field}
    |> Changeset.cast(params, Map.keys(field))
    |> Changeset.validate_required([:id], message: "Enter id")
    |> validate_transaction_exist()
    |> is_valid_changeset?()
  end

  #params validator for update transaction add categories
  def validate_params(:update_transaction_add_categories, params) do
    fields = %{
      id: :integer,
      category: {:array, :integer}
    }

    {%{}, fields}
    |> Changeset.cast(params, Map.keys(fields))
    |> Changeset.validate_required([:id], message: "Enter id")
    |> validate_transaction_exist()
    |> validate_category()
    |> validate_transaction_category_by_id()
    |> is_valid_changeset?()
  end

  #params validator for update transaction remove categories
  def validate_params(:update_transaction_remove_categories, params) do
    fields = %{
      id: :integer,
      category: {:array, :string}
    }

    {%{}, fields}
    |> Changeset.cast(params, Map.keys(fields))
    |> Changeset.validate_required([:id], message: "Enter id")
    |> validate_transaction_exist()
    |> is_valid_changeset?()
  end  

  #check if no params category
  def validate_category(%{changes: %{category: []},
    valid?: true} = changeset) do
    Changeset.add_error(changeset, :category, "Enter Category")
  end

  #check if no params category
  def validate_category(%{changes: %{category: [""]},
    valid?: true} = changeset) do
    Changeset.add_error(changeset, :category, "Enter Category")
  end

  def validate_category(changeset), do: changeset

  # check if transaction exist, return 0/1
  def validate_transaction_exist(%{changes: %{id: id}, 
    valid?: true} = changeset) do
  
    Transaction
    |> where([a], a.id == ^id)
    |> select([a], count(a.id))
    |> limit(1)
    |> Repo.one()
    |> validate_transaction_exist(changeset)
  end
  def validate_transaction_exist(changeset), do: changeset

  # if 1, transaction is exist, continue, changeset valid true
  def validate_transaction_exist(1, changeset), do: changeset

  # if 0, transaction is not exist, add error message, changeset valid false
  def validate_transaction_exist(0, changeset), do:
    Changeset.add_error(changeset, :id, "Transaction does not exist.")

  # check type if credit, if amount credit is  null return false
  def validate_debit_credit(%{changes: %{type: "credit"},
    valid?: true} = changeset) do
    
    changeset.changes
    |> Map.has_key?(:amount_credit)
    |> validate_credit(changeset)
  end

  # check type if debit, if amount debit is null return false
  def validate_debit_credit(%{changes: %{type: "debit"},
    valid?: true} = changeset) do

    changeset.changes
    |> Map.has_key?(:amount_debit)
    |> validate_debit(changeset)
  end

  # if no errors goes here..
  def validate_debit_credit(changeset), do: changeset

  # if validate_debit_credit function return false, goes here, add error
  def validate_credit(false, changeset), do:
    Changeset.add_error(changeset, :amount_credit, "Enter amount credit")

  def validate_credit(_, changeset), do: changeset

  # if validate_debit_credit function return false, goes here, add error
  def validate_debit(false, changeset), do:
    Changeset.add_error(changeset, :amount_debit, "Enter amount debit")

  def validate_debit(_, changeset), do: changeset

  #validate if account is already have account type name (return 1/0)
  def validate_account_name_exist(%{changes: %{account: account},
    valid?: true} = changeset) do

    Account
    |> where([a], a.name == ^account)
    |> select([a], count(a.name))
    |> limit(1)
    |> Repo.one()
    |> validate_account_name_exist(changeset)
  end
  def validate_account_name_exist(changeset), do: changeset

  # if 0 name account name doest not exist error
  def validate_account_name_exist(0, changeset), do:
    Changeset.add_error(changeset, :id, "Account does not exist.")  

  # if _ name already exist return error message
  def validate_account_name_exist(_, changeset), do: changeset

  # function validate if category are not yet exist, add if not exist.
  def validate_category_if_not_exist_create(%{changes: %{category: category},
    valid?: true} = changeset) do

    categories = 
      TransactionCategory
      |> select([tc], tc.name)
      |> Repo.all()

    cat_not_exist = category -- categories
    create_category_does_not_exist(cat_not_exist, changeset)
  end

  # if no category params still proceed, return changeset
  def validate_category_if_not_exist_create(changeset), do: changeset

  # All category are already added proceed, valid true, return changeset
  def create_category_does_not_exist([], changeset), do: changeset

  # if category params are empty, valid true, return changeset
  def create_category_does_not_exist([""], changeset), do: changeset

  # Add all category that not exist.
  def create_category_does_not_exist(category, changeset) do
    Enum.map(category, fn cat -> 
      %TransactionCategory{}
      |> TransactionCategory.changeset(%{
        name: cat,
        deleted: false
      })
      |> Repo.insert!()
    end)
    changeset
  end


  #validate if category is already in trans category name (return 1/0)
  def validate_transaction_category(%{changes: %{category: category},
    valid?: true} = changeset) do

    categories =
      TransactionCategory
      |> select([tc], tc.name)
      |> Repo.all()
    
    cat_not_exist = category -- categories
    validate_transaction_category(cat_not_exist, changeset)
  end
  def validate_transaction_category(changeset), do: changeset

  # if [] result all category are valid
  def validate_transaction_category([], changeset), do: changeset

  # if not empty array the result, other category not exist, return error message
  def validate_transaction_category(cat_not_exist, changeset) do
    Changeset.add_error(changeset, :category, "Category: #{Enum.join(cat_not_exist, ", ")} are not exist.")  
  end

    #validate if category is already in trans category name (return 1/0)
  def validate_transaction_category_by_id(%{changes: %{category: category},
    valid?: true} = changeset) do

    categories =
      TransactionCategory
      |> select([tc], tc.id)
      |> Repo.all()
    
    cat_not_exist = category -- categories
    validate_transaction_category_by_id(cat_not_exist, changeset)
  end
  def validate_transaction_category_by_id(changeset), do: changeset

  # if [] result all category are valid
  def validate_transaction_category_by_id([], changeset), do: changeset

  # if not empty array the result, other category not exist, return error message
  def validate_transaction_category_by_id(cat_not_exist, changeset) do
    Changeset.add_error(changeset, :category, "Category id: #{Enum.join(cat_not_exist, ", ")} are not exist.")  
  end

  # catcher if create transaction changeset has error, cant update the transaction
  def create_transaction({:error, changeset}), do: {:error, changeset}
  def create_transaction(params) do
    {a, _} = Float.parse(params[:amount] || "0")
    {ac, _} = Float.parse(params[:amount_credit] || "0")
    {ad, _} = Float.parse(params[:amount_debit] || "0")
    category = params[:category] || []
    new_date = UC.date_format(params.date)

    params =
      params
      |> Map.put(:amount, a)
      |> Map.put(:amount_credit, ac)
      |> Map.put(:amount_debit, ad)
      |> Map.put(:date, new_date)
      |> Map.put(:deleted, false)
      |> Map.put(:category, category)

    create_transaction(:create, params)
  end

  def create_transaction(:create, params) do
    transaction =
      %Transaction{}
      |> Transaction.changeset(params)
      |> Repo.insert()
      |> broadcast_return(:create_transaction)
  end

  # broadcast return if error in creating transaction
  def broadcast_return({:error, _}, :create_transaction), do: {:error, message: "Error creating transactions."}
  
  # broadcast return if error adding transactions category
  def broadcast_return({:error, _}, :utac), do: {:error, message: "Error Adding Transactions Category"}

  # broadcast return if error removing transactions category
  def broadcast_return({:error, _}, :utrc), do: {:error, message: "Error Removing Transactions Category"}

  # broadcast return for creating transaction
  def broadcast_return(transaction, :create_transaction) do
    transaction
    |> broadcast_change([:transactions, :created])

    {:ok, transaction} = transaction

    %{transaction: transaction}
  end

  # broadcast return for adding transactions category
  def broadcast_return(transaction, :utac) do
    transaction
    |> broadcast_change([:transactions, :updated])
    result_checker(transaction, :update)
  end

  # broadcast return for removing transactions category
  def broadcast_return(transaction, :utrc) do
    transaction
    |> broadcast_change([:transactions, :updated])
    result_checker(transaction, :update)
  end

  # catcher if update transaction changeset has error, cant update the transaction
  def update_transaction({:error, changeset}), do: {:error, changeset}
  def update_transaction(params) do
    params = update_transaction_params(params)
    transaction = get_transaction_by_id(params.id)
    update_transaction(transaction, params)
  end

  def update_transaction(transaction, params) do
    transaction
    |> Transaction.changeset(params)
    |> Repo.update()
    |> result_checker(:update)
  end

  def update_transaction_params(params) do
    {a, _} = Float.parse(params[:amount] || "0")
    {ac, _} = Float.parse(params[:amount_credit] || "0")
    {ad, _} = Float.parse(params[:amount_debit] || "0")
    new_date = UC.date_format(params.date)

    params =
      params
      |> Map.put(:amount, a)
      |> Map.put(:amount_credit, ac)
      |> Map.put(:amount_debit, ad)
      |> Map.put(:date, new_date)
      |> Map.put(:description, params[:description] || "")
      |> Map.put(:notes, params[:notes] || "")

    params
  end

  # catcher if delete transaction changeset has error, cant delete the transaction
  def delete_transaction({:error, changeset}), do: {:error, changeset}
  def delete_transaction(params) do
    transaction = get_transaction_by_id(params.id)
    delete_transaction(transaction, %{deleted: true})
  end

  def delete_transaction(transaction, params) do
    transaction
    |> Transaction.changeset(params)
    |> Repo.update()
    |> result_checker(:delete)
  end

  # get all transaction data
  def get_all_of_transactions(), do: Transaction |> Repo.all()

  # catcher if get transaction changeset has error, cant get the transaction
  def get_transaction({:error, changeset}), do: {:error, changeset}
  def get_transaction(params), do: get_transaction_by_id(params.id)

  # get transaction data by id
  def get_transaction_by_id(id), do: Transaction |> Repo.get_by(%{id: id})

  # catcher if update transaction add categories changeset has error, cant add categories to the transaction
  def update_transaction_add_categories({:error, changeset}), do: {:error, changeset}
  def update_transaction_add_categories(params) do

    # call function to get transaction category name by id
    category = get_transaction_category_name_by_id(
        params[:category] || []
      )

    transaction = get_transaction_by_id(params[:id])
    category = category -- transaction.category
    new_category = transaction.category ++ category
    update_transaction_add_categories(transaction, new_category)
  end

  # catcher if update transaction remove categories changeset has error, cant add categories to the transaction
  def update_transaction_remove_categories({:error, changeset}), do: {:error, changeset}
  def update_transaction_remove_categories(params) do
    category = if params[:category] == [""], do: [], else: params[:category] || []
    transaction = get_transaction_by_id(params[:id])
    remaining_category = transaction.category -- category
    update_transaction_remove_categories(transaction, remaining_category)
  end

  # catcher function incase transaction is nil
  def update_transaction_add_categories(nil, nc), do: nil
  # update transaction category function with new category arguments
  def update_transaction_add_categories(transaction, nc) do
    transaction
    |> Transaction.changeset(%{category: nc})
    |> Repo.update()
    |> broadcast_return(:utac)
  end

  # catcher function incase transaction is nil
  def update_transaction_remove_categories(nil, rc), do: nil
  # update transaction category function with a remaining category arguments
  def update_transaction_remove_categories(transaction, rc) do
    transaction
    |> Transaction.changeset(%{category: rc})
    |> Repo.update()
    |> broadcast_return(:utrc)
  end

  # function to get the category name by its id
  # if [] no category params
  def get_transaction_category_name_by_id([]), do: []
  # if not [] query Transaction category and get the name by id
  def get_transaction_category_name_by_id(category) do
    category
    |> Enum.map(fn cid -> 
      TransactionCategory
      |> select([tc], tc.name)
      |> where([tc], tc.id == ^cid)
      |> Repo.one()
    end)
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

  ################ LIVE VIEW REPO FUNCTION ###########################

  def list_transactions do
    Transaction
    |> order_by([t], asc: t.created_at)
    |> Repo.all()
  end

  def get_transactions_category_by_id(nil), do: nil
  def get_transactions_category_by_id(id) do
    Transaction
    |> select([tc], tc.category)
    |> where([tc], tc.id == ^id)
    |> Repo.one()
  end

  def update_transaction_category(transaction, ntc) do
    transaction
    |> Transaction.changeset(%{category: ntc})
    |> Repo.update()
    |> broadcast_change([:transactions, :updated])
  end
end