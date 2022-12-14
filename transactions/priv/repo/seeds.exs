# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Transactions.Repo.insert!(%Transactions.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.



seed_data = [

  # account types
  %Transactions.Schemas.AccountType{
    name: "Debit Card",
  },
  %Transactions.Schemas.AccountType{
    name: "Credit Card",
  },
  %Transactions.Schemas.AccountType{
    name: "Assets",
  },

  # accounts
  %Transactions.Schemas.Account{
    name: "Bofa Personal",
    type: "Debit Card",
    balance_start: 123.45,
  },
  %Transactions.Schemas.Account{
    name: "Bofa Business",
    type: "Debit Card",
    balance_start: 123.45,
  },
  %Transactions.Schemas.Account{
    name: "Chase Personal",
    type: "Debit Card",
    balance_start: 123.45,
  },

  # transaction categories
  %Transactions.Schemas.TransactionCategory{
    name: "Category 1",
  },
  %Transactions.Schemas.TransactionCategory{
    name: "Category 2",
  },
  %Transactions.Schemas.TransactionCategory{
    name: "Category 3",
  },
  %Transactions.Schemas.TransactionCategory{
    name: "Category 4",
  },

  # transactions
  %Transactions.Schemas.Transaction{
    date: ~N[2010-04-18 14:00:00],
    description: "transaction description",
    original_description: "original description",
    amount: 123.12,
    amount_debit: 0.00,
    amount_credit: 765.22,
    type: "credit",
    account: "Bofa Business",
    category: ["Category 2"],
    notes: "this is notes",
  },
  %Transactions.Schemas.Transaction{
    date: ~N[2010-04-19 14:00:00],
    description: "transaction description",
    original_description: "original description",
    amount: 123.12,
    amount_debit: 0.00,
    amount_credit: 765.22,
    type: "credit",
    account: "Bofa Personal",
    category: ["Category 1"],
    notes: "this is notes",
  },
  %Transactions.Schemas.Transaction{
    date: ~N[2010-04-20 14:00:00],
    description: "transaction description",
    original_description: "original description",
    amount: 123.12,
    amount_debit: 0.00,
    amount_credit: 765.22,
    type: "credit",
    account: "Bofa Personal",
    category: ["Category 2", "Category 1"],
    notes: "this is notes",
  },
  %Transactions.Schemas.Transaction{
    date: ~N[2010-04-21 14:00:00],
    description: "transaction description",
    original_description: "original description",
    amount: 123.12,
    amount_debit: 0.00,
    amount_credit: 765.22,
    type: "credit",
    account: "Bofa Business",
    category: ["Category 2"],
    notes: "this is notes",
  },
  %Transactions.Schemas.Transaction{
    date: ~N[2010-04-21 14:00:00],
    description: "transaction description",
    original_description: "original description",
    amount: 123.12,
    amount_debit: 0.00,
    amount_credit: 765.22,
    type: "credit",
    account: "Bofa Personal",
    category: ["Category 2"],
    notes: "this is notes",
  }
]


Enum.each(seed_data, fn(data) ->
  Transactions.Repo.insert!(data)
end)
