defmodule TransactionsWeb.TransactionTest do
  use TransactionsWeb.ConnCase

  @moduledoc """
    Transaction Unit Test File
  """

  describe "create transaction" do

    test "with valid params type credit" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)
      insert(:transaction_category, id: 2, name: "Category 2", deleted: false)

      query = """
        mutation {
          CreateTransaction(
            date: "JAN-01-2021",
            description: "transaction description",
            original_description: "original description",
            amount: "123.12",
            amount_debit: "",
            amount_credit: "765.22",
            type: "credit",
            account: "Account 1",
            category: ["Category 1"],
            notes: "this is notes"
          ) {
            transaction {
              date
              description
              original_description
              amount
              amount_credit
              amount_debit
              type
              account
              category
              notes
              deleted
              created_at
              updated_at
            }
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]
      assert result["CreateTransaction"]["transaction"]["account"] == "Account 1"
      assert result["CreateTransaction"]["transaction"]["category"] == ["Category 1"]
      assert result["CreateTransaction"]["transaction"]["amount_credit"] == 765.22
    end

    test "with valid params type debit" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)

      query = """
        mutation {
          CreateTransaction(
            date: "JAN-01-2021",
            description: "transaction description",
            original_description: "original description",
            amount: "123.12",
            amount_debit: "2314.22",
            amount_credit: "",
            type: "debit",
            account: "Account 1",
            category: ["Category 1"]
            notes: "this is notes"
          ) {
            transaction {
              date
              description
              original_description
              amount
              amount_credit
              amount_debit
              type
              account
              category
              notes
              deleted
              created_at
              updated_at
            }
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]
      assert result["CreateTransaction"]["transaction"]["account"] == "Account 1"
      assert result["CreateTransaction"]["transaction"]["category"] == ["Category 1"]
      assert result["CreateTransaction"]["transaction"]["amount_debit"] == 2314.22
    end

    test "with no date params" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)

      query = """
        mutation {
          CreateTransaction(
            date: "",
            description: "transaction description",
            original_description: "original description",
            amount: "123.12",
            amount_debit: "2314.22",
            amount_credit: "",
            type: "debit",
            account: "Account 1",
            category: "Category 1"
            notes: "this is notes"
          ) {
            transaction {
              date
              description
              original_description
              amount
              amount_credit
              amount_debit
              type
              account
              category
              notes
              deleted
              created_at
              updated_at
            }
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Enter date"
    end

    test "with invalid type params" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)

      query = """
        mutation {
          CreateTransaction(
            date: "JAN-01-2021",
            description: "transaction description",
            original_description: "original description",
            amount: "123.12",
            amount_debit: "2314.22",
            amount_credit: "",
            type: "InvalidParams",
            account: "Account 1",
            category: ["Category 1"]
            notes: "this is notes"
          ) {
            transaction {
              date
              description
              original_description
              amount
              amount_credit
              amount_debit
              type
              account
              category
              notes
              deleted
              created_at
              updated_at
            }
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Type is Invalid. Allowed values: credit and debit"
    end

    test "with type is credit but no amount credit" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)

      query = """
        mutation {
          CreateTransaction(
            date: "JAN-01-2021",
            description: "transaction description",
            original_description: "original description",
            amount: "123.12",
            amount_debit: "",
            amount_credit: "",
            type: "credit",
            account: "Account 1",
            category: "Category 1"
            notes: "this is notes"
          ) {
            transaction {
              date
              description
              original_description
              amount
              amount_credit
              amount_debit
              type
              account
              category
              notes
              deleted
              created_at
              updated_at
            }
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Enter amount credit"
    end

    test "with type is debit but no amount debit" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)

      query = """
        mutation {
          CreateTransaction(
            date: "JAN-01-2021",
            description: "transaction description",
            original_description: "original description",
            amount: "123.12",
            amount_debit: "",
            amount_credit: "",
            type: "debit",
            account: "Account 1",
            category: "Category 1"
            notes: "this is notes"
          ) {
            transaction {
              date
              description
              original_description
              amount
              amount_credit
              amount_debit
              type
              account
              category
              notes
              deleted
              created_at
              updated_at
            }
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Enter amount debit"
    end

    test "with transaction category does not exist create" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)

      query = """
        mutation {
          CreateTransaction(
            date: "JAN-01-2021",
            description: "transaction description",
            original_description: "original description",
            amount: "123.12",
            amount_debit: "22.23",
            amount_credit: "",
            type: "debit",
            account: "Account 1",
            category: ["Category 2", "not exist"]
            notes: "this is notes"
          ) {
            transaction {
              date
              description
              original_description
              amount
              amount_credit
              amount_debit
              type
              account
              category
              notes
              deleted
              created_at
              updated_at
            }
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]
      assert result["CreateTransaction"]["transaction"]["category"] == ["Category 2", "not exist"]
    end

    test "with no transaction category params" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)

      query = """
        mutation {
          CreateTransaction(
            date: "JAN-01-2021",
            description: "transaction description",
            original_description: "original description",
            amount: "123.12",
            amount_debit: "22.23",
            amount_credit: "",
            type: "debit",
            account: "Account 1",
            notes: "this is notes"
          ) {
            transaction {
              date
              description
              original_description
              amount
              amount_credit
              amount_debit
              type
              account
              category
              notes
              deleted
              created_at
              updated_at
            }
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]
      assert result["CreateTransaction"]["transaction"]["category"] == []
    end
  end

  describe "update transaction" do

    test "with valid params" do
      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)
      insert(:transaction,
        id: 1,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Account 1",
        category: ["Category 1"],
        original_description: "Test only"
      )

      query = """
        mutation {
          UpdateTransaction(
            id: "1"
            date: "JAN-01-2021",
            original_description: "original description",
            amount: "123.12",
            amount_debit: "",
            amount_credit: "765.22",
            type: "credit",
            account: "Account 1",
            category: ["Category 1"]
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]
      assert result["UpdateTransaction"]["message"] == "Successfully Updated"
    end

    test "with transaction does not exist" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)
      insert(:transaction,
        id: 1,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Account 1",
        category: ["Category 1"],
        original_description: "Test only"
      )

      query = """
        mutation {
          UpdateTransaction(
            id: "2"
            date: "JAN-01-2021",
            original_description: "original description",
            amount: "123.12",
            amount_debit: "",
            amount_credit: "765.22",
            type: "credit",
            account: "Account 1",
            category: ["Category 1"]
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Transaction does not exist."
    end

    test "with with no id params" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)
      insert(:transaction,
        id: 1,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Account 1",
        category: ["Category 1"],
        original_description: "Test only"
      )

      query = """
        mutation {
          UpdateTransaction(
            id: ""
            date: "JAN-01-2021",
            original_description: "original description",
            amount: "123.12",
            amount_debit: "",
            amount_credit: "765.22",
            type: "credit",
            account: "Account 1",
            category: ["Category 1"]
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Enter id"
    end
  end

  describe "delete account" do

    test "with valid params" do
      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)
      insert(:transaction,
        id: 1,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Account 1",
        category: ["Category 1"],
        original_description: "Test only"
      )

      query = """
        mutation {
          DeleteTransaction(id: "1") {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]
      assert result["DeleteTransaction"]["message"] == "Successfully Deleted"
    end

    test "with no id params" do
      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)
      insert(:transaction,
        id: 1,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Account 1",
        category: ["Category 1"],
        original_description: "Test only"
      )

      query = """
        mutation {
          DeleteTransaction(id: "") {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Enter id"
    end

    test "with transaction does not exist" do
      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)
      insert(:transaction,
        id: 1,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Account 1",
        category: ["Category 1"],
        original_description: "Test only"
      )

      query = """
        mutation {
          DeleteTransaction(id: "2") {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Transaction does not exist."
    end
  end

  describe "get all transactions" do
    test "with valid data" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)
      insert(:transaction,
        id: 1,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Account 1",
        category: ["Category 1"],
        original_description: "Test only"
      )

      insert(:account_type, id: 2, name: "Assets", deleted: false)
      insert(:account,
        id: 2,
        name: "Account 2",
        balance_start: 1423.45,
        type: "Assets",
        deleted: false)
      insert(:transaction_category, id: 2, name: "Category 2", deleted: false)
      insert(:transaction,
        id: 2,
        date: NaiveDateTime.local_now(),
        type: "debit",
        account: "Account 2",
        category: ["Category 2"],
        original_description: "Test only 2"
      )

      query = """
        query {
          Transactions {
            id
            date
            type
            account
            category
            original_description
            deleted
            created_at
            updated_at
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "plain/text"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]
      assert result["Transactions"] != []
    end

    test "with no data" do

      query = """
        query {
          Transactions {
            id
            date
            type
            account
            category
            original_description
            deleted
            created_at
            updated_at
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "plain/text"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]
      assert result["Transactions"] == []
    end
  end

  describe "get transaction by id" do

    test "with valid data" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)
      insert(:transaction,
        id: 1,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Account 1",
        category: ["Category 1"],
        original_description: "Test only"
      )

      query = """
        query {
          transaction(id: "1") {
            id
            date
            type
            account
            category
            original_description
            deleted
            created_at
            updated_at
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "plain/text"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]
      assert result["transaction"]["id"] == "1"
    end

    test "with data does not exist" do

      query = """
        query {
          transaction(id: "1") {
            id
            date
            type
            account
            category
            original_description
            deleted
            created_at
            updated_at
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "plain/text"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Transaction does not exist."
    end
  end

  describe "update transaction add categories" do
    test "with valid params" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)
      insert(:transaction_category, id: 2, name: "Category 2", deleted: false)
      insert(:transaction_category, id: 3, name: "Category 3", deleted: false)


      insert(:transaction,
        id: 1,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Account 1",
        category: ["Category 3"],
        original_description: "Test only"
      )

      query = """
        mutation {
          UpdateTransactionAddCategories(
            id: 1,
            category: [1, 2]
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]
      result["UpdateTransactionAddCategories"]["message"] == "Successfully Updated"
    end

    test "with transaction category does not exist" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)
      insert(:transaction_category, id: 2, name: "Category 2", deleted: false)
      insert(:transaction_category, id: 3, name: "Category 3", deleted: false)


      insert(:transaction,
        id: 1,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Account 1",
        category: ["Category 3"],
        original_description: "Test only"
      )

      query = """
        mutation {
          UpdateTransactionAddCategories(
            id: 1,
            category: [4, 5]
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Category id: 4, 5 are not exist."
    end

    test "with transaction does not exist" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)
      insert(:transaction_category, id: 2, name: "Category 2", deleted: false)

      insert(:transaction,
        id: 1,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Account 1",
        category: ["Category 3"],
        original_description: "Test only"
      )

      query = """
        mutation {
          UpdateTransactionAddCategories(
            id: 2,
            category: [1, 2]
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Transaction does not exist."
    end
  end

  describe "update transaction remove categories" do
    test "with valid params" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)
      insert(:transaction_category, id: 2, name: "Category 2", deleted: false)
      insert(:transaction_category, id: 3, name: "Category 3", deleted: false)

      insert(:transaction,
        id: 1,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Account 1",
        category: ["Category 3", "Category 1", "Category 2"],
        original_description: "Test only"
      )

      query = """
        mutation {
          UpdateTransactionRemoveCategories(
            id: 1,
            category: ["Category 3", "Category 2"]
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]
      result["UpdateTransactionAddCategories"]["message"] == "Successfully Updated"
    end

    test "with transaction does not exist" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Account 1",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)
      insert(:transaction_category, id: 2, name: "Category 2", deleted: false)
      insert(:transaction_category, id: 3, name: "Category 3", deleted: false)

      insert(:transaction,
        id: 1,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Account 1",
        category: ["Category 3", "Category 1", "Category 2"],
        original_description: "Test only"
      )

      query = """
        mutation {
          UpdateTransactionRemoveCategories(
            id: 2,
            category: ["Category 3", "Category 2"]
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Transaction does not exist."
    end
  end
end
