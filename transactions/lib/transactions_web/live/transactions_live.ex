defmodule TransactionsWeb.TransactionsLive do
  use TransactionsWeb, :live_view

  alias Transactions.Context.TransactionContext, as: TC
  alias Transactions.Context.TransactionCategoryContext, as: TCC

  # Callback  function for the first render
  def mount(_params, _session, socket) do
    TC.subscribe()
    {:ok, fetch(socket)}
  end

  # handle event for category selected, catcher function
  # if categories is "".
  def handle_event("category_selected",
    %{"transaction_categories" => ""},
    socket) do

    {:noreply, fetch(socket)}
  end

  # handle event for category selected, catcher function
  # if categories is nil.
  def handle_event("category_selected",
    %{"transaction_categories" => nil},
    socket) do

    {:noreply, fetch(socket)}
  end

  # handle event for category selected,
  # if data is valid proceed to update state.
  def handle_event("category_selected",
    %{"transaction_categories" => name},
    socket) do

    nid = String.split(name, ",") # Split the name variable from string, return 2 data name and id
    category = Enum.at(nid, 0) # First element is category
    id = Enum.at(nid, 1) # Second element is transaction id
    update_transaction_category(category, socket, id) # update transaction function
  end

  # update transaction category if category params is None and id is nil
  # return {:noreply}
  def update_transaction_category("None", socket, nil), do: {:noreply, fetch(socket)}

  # update function for valid category and transaction id
  def update_transaction_category(category, socket, id) do
    # get transaction by id
    transaction = TC.get_transaction_by_id(id)

    new_transaction_category = get_new_transaction_category(
      Enum.member?(transaction.category,
      category), transaction.category, category)

    TC.update_transaction_category(transaction, new_transaction_category)
    {:noreply, socket}
  end

  # if category is exist on that transaction remove the category
  def get_new_transaction_category(true, t_category, category), do: t_category -- [category]

  # if category is not exist on that transaction add the additional category
  def get_new_transaction_category(false, t_category, category), do: t_category ++ [category]

  # handle function callback for update
  def handle_info({TC, [:transactions | _], _}, socket) do
    {:noreply, fetch(socket)}
  end

  # fetch the socket, transactions, and transaction_categories data.
  def fetch(socket) do
    assign(
      socket,
      transactions: TC.list_transactions(),
      transaction_categories: TCC.list_transaction_categories(),
    )
  end

  # function to get the selected value and targeted transactions
  defp get_category_value(id, name), do: "#{name},#{id}"

  # function to identify if category if asscociate on that transaction
  def css_identifier(id, name) do
    tc = TC.get_transactions_category_by_id(id)
    tc
    |> Enum.member?(name)
    |> css_identifier()
  end

  # None if category is associated on that transactions then
  # css will gonna highlight the None value.
  def css_identifier(true), do: "None"
  # "" if category is not associated on that transactions will
  # not highlight the options field.
  def css_identifier(_), do: ""

  # call render function, after mounting.
  def render(assigns), do: generate_table(assigns)

  # function for select field in html
  def selected_categories(assigns, trans_id) do
    ~L"""
      <form phx-change="category_selected" phx-value="<%= trans_id %>">
        <select name="transaction_categories" id="transactions" multiple>
          <option value="">Select Category</option>
          <%= for tcc <- @transaction_categories do %>
            <option value="<%=  get_category_value(trans_id, tcc.name) %>"
              name="<%= css_identifier(trans_id, tcc.name)
              %>"
            >
            <%= tcc.name %>
          </option>
        <% end %>
        </select>
       </form>
    """
  end

  # function for table UI html
  def generate_table(assigns) do
    ~L"""
    <div>
      <h1>Transactions Table</h1>
      <hr style="width:230%;height:2px;border-width:0;color:gray;background-color:gray">
        <table class="transactions_table" style="width:100%">
          <thead>
            <tr>
              <th>ID</th>
              <th>Date</th>
              <th>Description</th>
              <th>Original Description</th>
              <th>Amount</th>
              <th>Amount Credit</th>
              <th>Amount Debit</th>
              <th>Type</th>
              <th>Account</th>
              <th>Category</th>
              <th>Notes</th>
              <th>Deleted</th>
              <th>Created At</th>
              <th>Updated At</th>
            </tr>
          </thead>
          <%= for trans <- @transactions do %>
            <tr>
              <td><%= trans.id || "N/A" %></td>
              <td><%= trans.date || "N/A" %></td>
              <td><%= trans.description || "N/A" %></td>
              <td><%= trans.original_description || "N/A" %></td>
              <td><%= trans.amount || "N/A" %></td>
              <td><%= trans.amount_credit || "N/A" %></td>
              <td><%= trans.amount_debit || "N/A" %></td>
              <td><%= trans.type || "N/A" %></td>
              <td><%= trans.account || "N/A" %></td>
              <td>
               <%= selected_categories(assigns, trans.id) %>
              </td>
              <td><%= trans.notes || "N/A" %></td>
              <td><%= trans.deleted || "N/A" %></td>
              <td><%= trans.created_at || "N/A" %></td>
              <td><%= trans.updated_at || "N/A" %></td>
            </tr>
          <% end %>
        </table>
    </div>
    """
  end
end
