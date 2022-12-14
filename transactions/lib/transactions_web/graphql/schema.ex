defmodule TransactionsWeb.Graphql.Schema do
  use Absinthe.Schema

  import_types(TransactionsWeb.Graphql.Schema.AccountType)
  import_types(TransactionsWeb.Graphql.Schema.Account)
  import_types(TransactionsWeb.Graphql.Schema.TransactionCategory)
  import_types(TransactionsWeb.Graphql.Schema.Transaction)

  query do
    import_fields(:account_type_queries)
    import_fields(:account_queries)
    import_fields(:transaction_category_queries)
    import_fields(:transaction_queries)
  end

  mutation do
    import_fields(:account_type_mutations)
    import_fields(:account_mutations)
    import_fields(:transaction_category_mutations)
    import_fields(:transaction_mutations)
  end
end