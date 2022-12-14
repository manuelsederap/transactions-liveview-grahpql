defmodule TransactionsWeb.TransactionCategoryTest do
  use TransactionsWeb.ConnCase

  @moduledoc """
    Transaction Category Unit Test File
  """

  describe "create transaction category" do
    test "with valid params" do
      query = """
        mutation {
          CreateTransactionCategory(
            name: "Test Category"
          ) {
            transaction_category {
              name
            }
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]["CreateTransactionCategory"]
      assert result["transaction_category"]["name"] == "Test Category"
    end

    test "with no params" do
      query = """
        mutation {
          CreateTransactionCategory(
            name: ""
          ) {
            transaction_category {
              name
            }
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Enter name"
    end

    test "with trans category already exist" do

      insert(:transaction_category, id: 1, name: "Test Account", deleted: false)

      query = """
        mutation {
          CreateTransactionCategory(
            name: "Test Account"
          ) {
            transaction_category {
              name
            }
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Transaction Category Name is already exist."
    end     
  end

  describe "update transaction category" do

    test "with valid params" do

    insert(:transaction_category, id: 1, name: "Test Account", deleted: false)

      query = """
        mutation {
          UpdateTransactionCategory(
            id: "1",
            name: "Test Account 2"
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]["UpdateTransactionCategory"]
      assert result["message"] == "Successfully Updated"
    end

    test "with no id" do

    insert(:transaction_category, id: 1, name: "Test Account", deleted: false)

      query = """
        mutation {
          UpdateTransactionCategory(
            id: "",
            name: "Test Account 2"
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

    test "with name already exist" do

    insert(:transaction_category, id: 1, name: "Test Account", deleted: false)

      query = """
        mutation {
          UpdateTransactionCategory(
            id: "1",
            name: "Test Account"
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Transaction Category Name is already exist."
    end

    test "with data does not exist" do

    insert(:transaction_category, id: 2, name: "Test Account2", deleted: false)

      query = """
        mutation {
          UpdateTransactionCategory(
            id: "1",
            name: "Test Account"
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Transaction Category ID does not exist"
    end

    test "with data with already deleted" do

    insert(:transaction_category, id: 1, name: "Test Account 2", deleted: true)

      query = """
        mutation {
          UpdateTransactionCategory(
            id: "1",
            name: "Test Account"
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Transaction category is already Deleted."
    end       
  end

  describe "delete transaction category" do

    test "with valid params" do

    insert(:transaction_category, id: 1, name: "Test Account", deleted: false)

      query = """
        mutation {
          DeleteTransactionCategory(
            id: "1"
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]["DeleteTransactionCategory"]
      assert result["message"] == "Successfully Deleted"
    end

    test "with no id params" do

    insert(:transaction_category, id: 1, name: "Test Account", deleted: false)

      query = """
        mutation {
          DeleteTransactionCategory(
            id: ""
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

    test "with data does not exist" do

    insert(:transaction_category, id: 2, name: "Test Account2", deleted: false)

      query = """
        mutation {
          DeleteTransactionCategory(
            id: "1"
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Transaction Category ID does not exist"
    end

    test "with data with already deleted" do

    insert(:transaction_category, id: 1, name: "Test Account 2", deleted: true)

      query = """
        mutation {
          DeleteTransactionCategory(
            id: "1"
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Transaction category is already Deleted."
    end    
  end

  describe "get all list of transaction category" do
    test "get all transaction categories" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)

      insert(:account,
        id: 1,
        name: "Test Account",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)

      insert(:transaction_category, id: 1, name: "Test Tc 1", deleted: false)
      insert(:transaction_category, id: 2, name: "Test Tc 2", deleted: false)
      insert(:transaction_category, id: 3, name: "Test Tc 3", deleted: false)

      insert(:transaction,
        id: 1,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Test Account",
        category: ["Test Tc 1"],
        original_description: "Test only 1"
      )

      insert(:transaction,
        id: 2,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Test Account",
        category: ["Test Tc 2"],
        original_description: "Test only 1"
      )

      insert(:transaction,
        id: 3,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Test Account",
        category: ["Test Tc 3"],
        original_description: "Test only 1"
      )

      query = """
        query {
          TransactionCategories {
            id
            name
            transactions {
              id
              date
              type
              account
              category
              original_description
            }
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "plain/text"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]
      assert result["TransactionCategories"] != []
    end
  end

  describe "get transaction category by id" do
    test "with valid params" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)

      insert(:account,
        id: 1,
        name: "Test Account",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)

      insert(:transaction_category, id: 1, name: "Test Tc 1", deleted: false)

      insert(:transaction,
        id: 1,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Test Account",
        category: ["Test Tc 1"],
        original_description: "Test only 1"
      )

      query = """
        query {
          TransactionCategory(id: "1") {
            id
            name
            transactions {
              id
              date
              type
              account
              category
              original_description
            }  
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "plain/text"),
        "/graphql", query)      

      result = json_response(conn, 200)["data"]
      result["TransactionCategory"]["id"] == 1
      result["TransactionCategory"]["name"] == "Test Tc 1"
      result["TransactionCategory"]["transactions"] != []
    end

    test "with no id params" do

      insert(:transaction_category, id: 1, name: "Test Tc 1", deleted: false)

      query = """
        query {
          TransactionCategory(id: "") {
            id
            name
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "plain/text"),
        "/graphql", query)      

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Enter id"
    end

    test "with transaction category does not exist" do

      insert(:transaction_category, id: 1, name: "Test Tc 1", deleted: false)

      query = """
        query {
          TransactionCategory(id: "2") {
            id
            name
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "plain/text"),
        "/graphql", query)      

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Transaction Category ID does not exist"
    end     
  end
end