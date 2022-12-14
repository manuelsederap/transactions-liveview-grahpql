# Phoenix Transactions GraphQL

## Requirements
- elixir 1.7
- phoenix 1.5.7
- postgres

## How to use?

To start your Phoenix server:

  ```
  $ mix deps.get                # download phoenix dependencies
  $ mix ecto.setup              # Create and migrate your databas
  $ npm install --prefix assets # Install Asset dependencies
  $ mix phx.server              # Start Phoenix endpoint
  ```

Endpoint: http://localhost:4000/graphql

Now you can visit [`http://localhost:4000/graphql`](http://localhost:4000/graphql) from your browser.

For Testing API, this is an example query below.

For Create AccountType

Request Body:
```graphql

mutation {
    CreateAccountType(
        name: "Assets"
    ) {
        account_type {
            id
            name
            deleted
            created_at
            updated_at
        }
    }
}

```

EXPECTED OUTPUT:

```json
{
    "data": {
        "CreateAccountType": {
            "account_type": {
                "updated_at": "2021-03-09 00:12:27",
                "name": "Assets",
                "id": 6,
                "deleted": false,
                "created_at": "2021-03-09 00:12:27"
            }
        }
    }
}
```

For Update Account Type

Request Body

```graphql
  mutation {
    UpdateAccountType(
        id: 6
        name: "Equity"
    ) {
        message
    }
}
```

Expected output:

```json
  {
    "data": {
        "UpdateAccountType": {
            "message": "Successfully Updated"
        }
    }
}
```

For Delete Account Type

Request Body

```graphql
mutation {
    DeleteAccountType(
        id: 1
    ) {
        message
    }
}
```

Expected output:

```json
  {
    "data": {
        "DeleteAccountType": {
            "message": "Successfully Deleted"
        }
    }
}
```

For Account Type Queries

Get All list of Account types

Request Body

```graphql
query {
  AccountTypes {
    name
    id
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
```

Expected output:

```json
{
    "data": {
        "AccountTypes": [
            {
                "id": 1,
                "name": "TesTCA2",
                "transactions": [
                    {
                        "account": "Test_Account_type_2",
                        "category": "Update Trans Category",
                        "date": "2021-01-02 00:00:00",
                        "id": "1",
                        "original_description": "original description",
                        "type": "credit"
                    }
                ]
            },
            {
                "id": 2,
                "name": "Equity",
                "transactions": [
                    {
                        "account": "Account_Equity_1",
                        "category": "Transaction Category 1",
                        "date": "2021-01-01 00:00:00",
                        "id": "2",
                        "original_description": "original description",
                        "type": "credit"
                    },
                    {
                        "account": "Account_Equity_2",
                        "category": "Transaction Category 2",
                        "date": "2021-01-01 00:00:00",
                        "id": "3",
                        "original_description": "original description",
                        "type": "credit"
                    }
                ]
            },
            {
                "id": 3,
                "name": "Assets",
                "transactions": [
                    {
                        "account": "Account_Assets_2",
                        "category": "Transaction Category 2",
                        "date": "2021-01-01 00:00:00",
                        "id": "4",
                        "original_description": "original description",
                        "type": "credit"
                    },
                    {
                        "account": "Account_Assets_3",
                        "category": "Transaction Category 3",
                        "date": "2021-01-01 00:00:00",
                        "id": "5",
                        "original_description": "original description",
                        "type": "credit"
                    }
                ]
            },
            {
                "id": 4,
                "name": "Liability",
                "transactions": []
            }
        ]
    }
}
```

Get Account type by id

Request Body

```graphql
query {
  AccountType(id: 2) {
      name
      id
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
}
```

Expected Output:
```json
{
    "data": {
        "AccountType": {
            "id": 2,
            "name": "Equity",
            "transactions": [
                {
                    "account": "Account_Equity_1",
                    "category": "Transaction Category 1",
                    "date": "2021-01-01 00:00:00",
                    "id": "2",
                    "original_description": "original description",
                    "type": "credit"
                },
                {
                    "account": "Account_Equity_2",
                    "category": "Transaction Category 2",
                    "date": "2021-01-01 00:00:00",
                    "id": "3",
                    "original_description": "original description",
                    "type": "credit"
                }
            ]
        }
    }
}
```


For Account Schemas

Account Mutations

Create Account

Request Body:

```graphql
mutation {
    CreateAccount(
        name: "Test_Account_type_1",
        type: "Equity",
        balance_start: 123.45
    ) {
        account {
            name
            type
            balance_start
        }
    }
}
```

Expected Output:

```json
{
    "data": {
        "CreateAccount": {
            "account": {
                "balance_start": 123.45,
                "name": "Test_Account_type_1",
                "type": "Equity"
            }
        }
    }
}
```

Update Account

Request Body:

```graphql
mutation {
  UpdateAccount(
    id: "1",
    name: "TestAccount",
    Type: "Assets",
    balance_start: "123.45"
  ) {
    message
  }
}
```

Expected Output:

```json
{
    "data": {
        "UpdateAccount": {
            "message": "Successfully Updated"
        }
    }
}
```

Delete Account

Request Body:

```graphql
mutation {
    DeleteAccount(
        id: "1"
    ) {
        message
    }
}
```

Expected Output:

```json
{
    "data": {
        "DeleteAccount": {
            "message": "Successfully Deleted"
        }
    }
}
```

Account Query

Get All Accounts

Request Body

```graphql
query {
query {
    Accounts{
         name
         balance_start
         type
         transactions {
            id
            date
            type
            category
            original_description
         }
    }
}
```

Expected Output:
```json
{
    "data": {
        "Accounts": [
            {
                "balance_start": 123.45,
                "name": "Test_Account_type_2",
                "transactions": [
                    {
                        "category": "Update Trans Category",
                        "date": "2021-01-02 00:00:00",
                        "id": "1",
                        "original_description": "original description",
                        "type": "credit"
                    }
                ],
                "type": "TesTCA2"
            },
            {
                "balance_start": 123.45,
                "name": "Test_Account_type_3",
                "transactions": [],
                "type": "TesTCA2"
            },
            {
                "balance_start": 123.45,
                "name": "Test_Account_type_4",
                "transactions": [],
                "type": "TesTCA2"
            },
            {
                "balance_start": 444.45,
                "name": "TestAccount",
                "transactions": [],
                "type": "TesTCA2"
            },
            {
                "balance_start": 214.23,
                "name": "Account_Equity_1",
                "transactions": [
                    {
                        "category": "Transaction Category 1",
                        "date": "2021-01-01 00:00:00",
                        "id": "2",
                        "original_description": "original description",
                        "type": "credit"
                    }
                ],
                "type": "Equity"
            },
            {
                "balance_start": 555.21,
                "name": "Account_Equity_2",
                "transactions": [
                    {
                        "category": "Transaction Category 2",
                        "date": "2021-01-01 00:00:00",
                        "id": "3",
                        "original_description": "original description",
                        "type": "credit"
                    }
                ],
                "type": "Equity"
            },
            {
                "balance_start": 5523.0,
                "name": "Account_Equity_3",
                "transactions": [],
                "type": "Equity"
            },
            {
                "balance_start": 112.0,
                "name": "Account_Assets_1",
                "transactions": [],
                "type": "Equity"
            },
            {
                "balance_start": 112.0,
                "name": "Account_Assets_2",
                "transactions": [
                    {
                        "category": "Transaction Category 2",
                        "date": "2021-01-01 00:00:00",
                        "id": "4",
                        "original_description": "original description",
                        "type": "credit"
                    }
                ],
                "type": "Assets"
            },
            {
                "balance_start": 112.0,
                "name": "Account_Assets_3",
                "transactions": [
                    {
                        "category": "Transaction Category 3",
                        "date": "2021-01-01 00:00:00",
                        "id": "5",
                        "original_description": "original description",
                        "type": "credit"
                    }
                ],
                "type": "Assets"
            }
        ]
    }
}
```

Get Account

Request Body:

```graphql
query {
    account(id: "2"){
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
```

Expected Output:

```json
{
    "data": {
        "account": {
            "balance_start": 123.45,
            "name": "Test_Account_type_2",
            "transactions": [
                {
                    "account": "Test_Account_type_2",
                    "category": "Update Trans Category",
                    "date": "2021-01-02 00:00:00",
                    "id": "1",
                    "original_description": "original description",
                    "type": "credit"
                }
            ],
            "type": "TesTCA2"
        }
    }
}
```

For Transaction Category Schemas

Transaction Category Mutations

Create Transaction Category

Request Body:
```graphql
mutation {
  CreateTransactionCategory(
    name: "Test Category"
  ) {
    transaction_category {
      name
    }
  }
}
```

Expected Output:

```json
{
    "data": {
        "CreateTransactionCategory": {
            "transaction_category": {
                "name": "Test Transaction Category"
            }
        }
    }
}
```

Update Transaction Category

Request Body
```graphql
mutation {
    UpdateTransactionCategory(
        id: "1"
        name: "Update Trans Category"
    ) {
        message
    }
}
```

Expected Output:

```json
{
    "data": {
        "UpdateTransactionCategory": {
            "message": "Successfully Updated"
        }
    }
}
```

Delete Transaction Category

Request Body
```graphql
mutation {
    DeleteTransactionCategory(
        id: "1"
    ) {
        message
    }
}
```

Expected Output:

```json
{
    "data": {
        "DeleteTransactionCategory": {
            "message": "Successfully Deleted"
        }
    }
}
```

Transaction Category Query

Get All Transaction Category

Request Body:

```graphql
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
```

Expected Output:

```json
{
    "data": {
        "TransactionCategories": [
            {
                "id": 1,
                "name": "Update Trans Category",
                "transactions": [
                    {
                        "account": "Test_Account_type_2",
                        "category": "Update Trans Category",
                        "date": "2021-01-02 00:00:00",
                        "id": "1",
                        "original_description": "original description",
                        "type": "credit"
                    }
                ]
            },
            {
                "id": 2,
                "name": "Transaction Category 1",
                "transactions": [
                    {
                        "account": "Account_Equity_1",
                        "category": "Transaction Category 1",
                        "date": "2021-01-01 00:00:00",
                        "id": "2",
                        "original_description": "original description",
                        "type": "credit"
                    }
                ]
            },
            {
                "id": 3,
                "name": "Transaction Category 2",
                "transactions": [
                    {
                        "account": "Account_Equity_2",
                        "category": "Transaction Category 2",
                        "date": "2021-01-01 00:00:00",
                        "id": "3",
                        "original_description": "original description",
                        "type": "credit"
                    },
                    {
                        "account": "Account_Assets_2",
                        "category": "Transaction Category 2",
                        "date": "2021-01-01 00:00:00",
                        "id": "4",
                        "original_description": "original description",
                        "type": "credit"
                    }
                ]
            },
            {
                "id": 4,
                "name": "Transaction Category 3",
                "transactions": [
                    {
                        "account": "Account_Assets_3",
                        "category": "Transaction Category 3",
                        "date": "2021-01-01 00:00:00",
                        "id": "5",
                        "original_description": "original description",
                        "type": "credit"
                    }
                ]
            },
            {
                "id": 5,
                "name": "Transaction Category 4",
                "transactions": []
            }
        ]
    }
}
```

Get Transaction Category by ID

Request Body:

```graphql
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
```

Expected Output:

```json
{
    "data": {
        "TransactionCategory": {
            "id": 1,
            "name": "Update Trans Category",
            "transactions": [
                {
                    "account": "Test_Account_type_2",
                    "category": "Update Trans Category",
                    "date": "2021-01-02 00:00:00",
                    "id": "1",
                    "original_description": "original description",
                    "type": "credit"
                }
            ]
        }
    }
}
```

For Transaction Schemas

Transaction Mutations

Create Transaction

Request Body:

```graphql
mutation {
  CreateTransaction(
    date: "JAN-01-2021",
    description: "transaction description",
    original_description: "original description",
    amount: "123.12",
    amount_debit: "",
    amount_credit: "765.22",
    type: "credit",
    account: "Test_Account_type_2",
    category: ["Update Trans Category"]
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
```

Expected Output:

```json
{
    "data": {
        "CreateTransaction": {
            "transaction": {
                "account": "Test_Account_type_2",
                "amount": 123.12,
                "amount_credit": 765.22,
                "amount_debit": 0.0,
                "category": "Update Trans Category",
                "created_at": "2021-03-11 03:51:11",
                "date": "2021-01-01 00:00:00",
                "deleted": false,
                "description": "transaction description",
                "notes": "this is notes",
                "original_description": "original description",
                "type": "credit",
                "updated_at": "2021-03-11 03:51:11"
            }
        }
    }
}
```

Update Transaction

Request Body:

```graphql
    mutation {
      UpdateTransaction(
        id: "1"
        date: "JAN-02-2021",
        original_description: "original description",
        amount: "123.12",
        amount_debit: "",
        amount_credit: "765.22",
        type: "credit",
        account: "Test_Account_type_2",
        category: ["Update Trans Category"]
      ) {
        message
      }
    }
```

Expected Output:

```json
{
    "data": {
        "UpdateTransaction": {
            "message": "Successfully Updated"
        }
    }
}
```

Delete Transaction

Request Body:

```graphql
mutation {
    DeleteTransaction(
        id: "1"
    ) {
        message
    }
}
```

Expected Output:

```json
{
    "data": {
        "DeleteTransaction": {
            "message": "Successfully Deleted"
        }
    }
}
```

Transaction Query

Get All Transaction

Request Body:

```graphql
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
```

Expected output:

```json
{
    "data": {
        "Transactions": [
            {
                "account": "Test_Account_type_2",
                "category": "Update Trans Category",
                "created_at": "2021-03-11 03:51:11",
                "date": "2021-01-02 00:00:00",
                "deleted": true,
                "id": "1",
                "original_description": "original description",
                "type": "credit",
                "updated_at": "2021-03-11 07:50:34"
            }
        ]
    }
}
```

Get Transaction by ID

Request Body:

```graphql
query {
  Transaction(id: "1") {
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
```

```json
{
    "data": {
        "Transaction": {
            "account": "Test_Account_type_2",
            "category": "Update Trans Category",
            "created_at": "2021-03-11 03:51:11",
            "date": "2021-01-02 00:00:00",
            "deleted": true,
            "id": "1",
            "original_description": "original description",
            "type": "credit",
            "updated_at": "2021-03-11 07:50:34"
        }
    }
}
```