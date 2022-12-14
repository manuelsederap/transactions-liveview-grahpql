defmodule Transactions.Schema do
  @moduledoc false
  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      alias Transactions.Repo
      
      @timestamps_opts [type: :naive_datetime]
    end
  end
end
