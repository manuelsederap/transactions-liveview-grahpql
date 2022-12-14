# Phoenix Transactions Management

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
  Then visit: http://localhost:4000
  GraphQL: http://localhost:4000/graphql

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

Update Transaction Add Categories

Request Body:

```graphql
mutation {
  UpdateTransactionAddCategories(
    id: 1,
    category: [1, 2]
  ) {
    message
  }
}
```

Sample Output:

```json
{
    "data": {
        "UpdateTransactionAddCategories": {
            "message": "Successfully Updated"
        }
    }
}
```

Update Transaction Remove Categories

Request Body:

```graphql
mutation {
  UpdateTransactionRemoveCategories(
    id: 1,
    category: ["Transaction Category 2"]
  ) {
    message
  }
}
```

Sample Output:

```json
{
    "data": {
        "UpdateTransactionRemoveCategories": {
            "message": "Successfully Updated"
        }
    }
}
```
