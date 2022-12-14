defmodule TransactionsWeb.AccountTest do
  use TransactionsWeb.ConnCase

  @moduledoc """
    Account Unit Test File
  """

  describe "create account" do
    test "with valid params" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      
      query = """
        mutation {
          CreateAccount(
            name: "TestAccount",
            Type: "Equity",
            balance_start: 123.45
          ) {
            account {
              name
              type
              balance_start
            }
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]["CreateAccount"]
      assert result["account"]["name"] == "TestAccount"
      assert result["account"]["type"] == "Equity"
    end

    test "with no type params" do
      
      query = """
        mutation {
          CreateAccount(
            name: "TestAccount",
            Type: "",
            balance_start: 123.45
          ) {
            account {
              name
              type
              balance_start
            }
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Enter Type"
    end

    test "with no name params" do
      
      query = """
        mutation {
          CreateAccount(
            name: "",
            Type: "Equity",
            balance_start: 123.45
          ) {
            account {
              name
              type
              balance_start
            }
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Enter name"
    end

    test "with account type does not exist" do
      
      query = """
        mutation {
          CreateAccount(
            name: "TestAccount",
            Type: "Equity",
            balance_start: 123.45
          ) {
            account {
              name
              type
              balance_start
            }
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Account Type not Exist."
    end    
  end

  describe "update account" do
    test "with valid params" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account_type, id: 2, name: "Assets", deleted: false)

      insert(:account,
        id: 1,
        name: "Test Account",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      
      query = """
        mutation {
          UpdateAccount(
            id: "1",
            name: "NewTestAccount",
            Type: "Assets",
            balance_start: "456.78"
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]
      assert result["UpdateAccount"]["message"] == "Successfully Updated"
    end

    test "with account does not exist" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account_type, id: 2, name: "Assets", deleted: false)

      insert(:account,
        id: 2,
        name: "Test Account",
        balance_start: 123.45,
        type: "Assets",
        deleted: false)
      
      query = """
        mutation {
          UpdateAccount(
            id: "1",
            name: "NewTestAccount",
            Type: "Assets",
            balance_start: "456.78"
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Account does not exist."
    end

    test "with account type does not exist" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account_type, id: 2, name: "Assets", deleted: false)

      insert(:account,
        id: 1,
        name: "Test Account",
        balance_start: 123.45,
        type: "Assets",
        deleted: false)
      
      query = """
        mutation {
          UpdateAccount(
            id: "1",
            name: "NewTestAccount",
            Type: "Liability",
            balance_start: "456.78"
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Account Type not Exist."
    end

    test "with no id params" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account_type, id: 2, name: "Assets", deleted: false)

      insert(:account,
        id: 1,
        name: "Test Account",
        balance_start: 123.45,
        type: "Assets",
        deleted: false)
      
      query = """
        mutation {
          UpdateAccount(
            id: "",
            name: "NewTestAccount",
            Type: "Liability",
            balance_start: "456.78"
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

    test "with no name params" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account_type, id: 2, name: "Assets", deleted: false)

      insert(:account,
        id: 1,
        name: "Test Account",
        balance_start: 123.45,
        type: "Assets",
        deleted: false)
      
      query = """
        mutation {
          UpdateAccount(
            id: "1",
            name: "",
            Type: "Liability",
            balance_start: "456.78"
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Enter name"
    end

    test "with no balance start params" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account_type, id: 2, name: "Assets", deleted: false)

      insert(:account,
        id: 1,
        name: "Test Account",
        balance_start: 123.45,
        type: "Assets",
        deleted: false)
      
      query = """
        mutation {
          UpdateAccount(
            id: "1",
            name: "TestAccount",
            Type: "Liability",
            balance_start: ""
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Enter balance start"
    end

    test "with no type params" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account_type, id: 2, name: "Assets", deleted: false)

      insert(:account,
        id: 1,
        name: "Test Account",
        balance_start: 123.45,
        type: "Assets",
        deleted: false)
      
      query = """
        mutation {
          UpdateAccount(
            id: "1",
            name: "TestAccount",
            Type: "",
            balance_start: "123.45"
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Enter type"
    end         
  end

  describe "delete account" do
    test "with valid params" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Test Account",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)

      query = """
        mutation {
          DeleteAccount(
            id: "1"
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]
      assert result["DeleteAccount"]["message"] == "Successfully Deleted"
    end

    test "with account does not exist" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 2,
        name: "Test Account",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)

      query = """
        mutation {
          DeleteAccount(
            id: "1"
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)
      
      assert List.first(json_response(conn, 200)["errors"])["message"] == "Account does not exist."
    end

    test "with no id params" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Test Account",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)

      query = """
        mutation {
          DeleteAccount(
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

    test "with transaction exist in account" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Test Account",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)
      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)
      insert(:transaction,
        id: 1,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Test Account",
        category: ["Category 1", "Category 2"],
        original_description: "Test only"
      )

      query = """
        mutation {
          DeleteAccount(
            id: "1"
          ) {
            message
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)
      
      assert List.first(json_response(conn, 200)["errors"])["message"] == "Account can't be deleted. It has transaction that exist."
    end     
  end

  describe "get all accounts" do
    test "with valid params" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Test Account",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)

      insert(:account,
        id: 2,
        name: "Test Account 2",
        balance_start: 456.78,
        type: "Equity",
        deleted: false)

      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)

      insert(:transaction,
        id: 1,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Test Account",
        category: ["Category 1"],
        original_description: "Test only 1"
      )

      insert(:transaction,
        id: 2,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Test Account 2",
        category: ["Category 1"],
        original_description: "Test only 2"
      )

      query = """
        query {
          accounts {
            name
            balance_start
            type
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
      assert result["accounts"] != []
    end
  end

  describe "get account by id" do

    test "with valid params" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Test Account",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)

      insert(:account,
        id: 2,
        name: "Test Account 2",
        balance_start: 456.78,
        type: "Equity",
        deleted: false)

      insert(:transaction_category, id: 1, name: "Category 1", deleted: false)

      insert(:transaction,
        id: 1,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Test Account",
        category: ["Category 1"],
        original_description: "Test only 1"
      )

      insert(:transaction,
        id: 2,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Test Account 2",
        category: ["Category 1"],
        original_description: "Test only 2"
      )

      query = """
        query {
          account(id: "1") {
            name
            balance_start
            type
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
      assert result["account"]["name"] == "Test Account"
      assert result["account"]["transactions"] != []
    end

    test "with account does not exist" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Test Account",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)

      insert(:account,
        id: 2,
        name: "Test Account 2",
        balance_start: 456.78,
        type: "Equity",
        deleted: false)

      query = """
        query {
          account(id: "3") {
            name
            balance_start
            type
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "plain/text"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Account does not exist."
    end

    test "with no id params" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account,
        id: 1,
        name: "Test Account",
        balance_start: 123.45,
        type: "Equity",
        deleted: false)

      insert(:account,
        id: 2,
        name: "Test Account 2",
        balance_start: 456.78,
        type: "Equity",
        deleted: false)

      query = """
        query {
          account(id: "") {
            name
            balance_start
            type
          }
        }
      """

      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "plain/text"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Enter id"
    end    
  end
end