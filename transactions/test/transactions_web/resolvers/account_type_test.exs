defmodule TransactionsWeb.AccountTypeTest do
  use TransactionsWeb.ConnCase

  @moduledoc """
    AccountType Unit Test file
  """

  describe "create account type" do
    test "with valid params" do
      query = """
        mutation {
          CreateAccountType(
            name: "Assets"
          ) {
            account_type {
              name
            }
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]["CreateAccountType"]
      assert result["account_type"]["name"] == "Assets"
    end

    test "with no params" do
      query = """
        mutation {
          CreateAccountType(
            name: ""
          ) {
            account_type {
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

    test "with already exist data" do

      insert(:account_type, id: 1, name: "Equity", deleted: false)

      query = """
        mutation {
          CreateAccountType(
            name: "Equity"
          ) {
            account_type {
              name
            }
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)
      
      assert List.first(json_response(conn, 200)["errors"])["message"] == "Account Type Name is already exist."
    end    
  end

  describe "update account type" do
    test "with valid params" do
      insert(:account_type, id: 1, name: "Equity", deleted: false)
      query = """
        mutation {
          UpdateAccountType(
            id: 1,
            name: "Assets"
          ) {
            message 
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]["UpdateAccountType"]
      assert result["message"] == "Successfully Updated"
    end

    test "with id does not exist" do
      insert(:account_type, id: 1, name: "Equity", deleted: false)
      query = """
        mutation {
          UpdateAccountType(
            id: 2,
            name: "Assets"
          ) {
            message 
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Account Type ID does not exist"
    end

    test "with account type already deleted" do
      insert(:account_type, id: 1, name: "Equity", deleted: true)
      query = """
        mutation {
          UpdateAccountType(
            id: 1,
            name: "Assets"
          ) {
            message 
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Account Type is already Deleted."
    end
  end

  describe "delete account type" do
    test "with valid params" do
      insert(:account_type, id: 1, name: "Equity", deleted: false)
      query = """
        mutation {
          DeleteAccountType(id: 1)
          {
            message 
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]["DeleteAccountType"]
      assert result["message"] == "Successfully Deleted"
    end

    test "with id does not exist" do
      insert(:account_type, id: 1, name: "Equity", deleted: false)
      query = """
        mutation {
          DeleteAccountType(id: 2) {
            message 
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Account Type ID does not exist"
    end

    test "with account type already deleted" do
      insert(:account_type, id: 1, name: "Equity", deleted: true)
      query = """
        mutation {
          DeleteAccountType(id: 1) {
            message 
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "video/raw"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] == "Account Type is already Deleted."
    end    
  end

  describe "Get all account types" do

    test "get list of account types" do
      insert(:account_type, id: 1, name: "Equity", deleted: false)
      insert(:account_type, id: 2, name: "Assets", deleted: false)
      insert(:account_type, id: 3, name: "Liability", deleted: false)

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
        original_description: "Test only 1"
      )

      insert(:transaction,
        id: 2,
        date: NaiveDateTime.local_now(),
        type: "credit",
        account: "Account 1",
        category: ["Category 1, Category 2, Category 3"],
        original_description: "Test only 2"
      )

      query = """
        query {
          AccountTypes {
            id
            name
            transactions {
              id
              date
              type
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
      assert result["AccountTypes"] != [] 
    end

    test "get list of account types with no data" do
      query = """
        query {
          AccountTypes {
            id
            name
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "plain/text"),
        "/graphql", query)

      result = json_response(conn, 200)["data"]
      assert result["AccountTypes"] == []
    end    
  end

  describe "get account type by id params" do

    test "get account type by id" do

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
        category: ["Category 1", "Category 2", "Category 3"],
        original_description: "Test only 1"
      )

      query = """
        query {
          AccountType(id: 1) {
            id
            name
            transactions {
              id
              date
              type
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
      assert result["AccountType"]["id"] == 1
      assert result["AccountType"]["name"] == "Equity"
      assert result["AccountType"]["transactions"] != []
    end

    test "get account type with no data" do
      query = """
        query {
          AccountType(id: 1) {
            id
            name
          }
        }
      """
      conn =
        post(Plug.Conn.put_req_header(build_conn(), "content-type", "plain/text"),
        "/graphql", query)

      assert List.first(json_response(conn, 200)["errors"])["message"] ==
        "Account Type ID does not exist"
    end    
  end
end
