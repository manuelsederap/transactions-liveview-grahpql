defmodule Transactions.Context.UtilityContext do
  @moduledoc """
    Context for reusable functions
  """
  
  alias Ecto.{
    Changeset,
    UUID
  }

  def handle_errors(fun) do
    fn source, args, info ->
      case Absinthe.Resolution.call(fun, source, args, info) do
        {:error, %Ecto.Changeset{} = changeset} -> format_changeset(changeset)
        val -> val
      end
    end
  end

  def format_changeset(changeset) do
    errors =
      changeset
      |> Ecto.Changeset.traverse_errors(fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)
      |> Enum.map(fn {field, message} ->
        field_name = Inflex.camelize(field, :lower)

        transform_error_message_graphql(field_name, message, field)
      end)

    {:error, errors}
  end

  def transform_error_message_graphql(field_name, message, _),
    do: %{message: "#{message}", field: field_name}

  
  def date_format(date) do
    if date == "" do
      nil
    else
      date1 =
        date
        |> String.slice(0..2)
        |> transform_date()

      date2 =
        date
        |> String.slice(3, 10)

      date = "#{date1}#{date2}"
      date |> Timex.parse!("{M}-{D}-{YYYY}")
    end
  end

  def transform_date("JAN"), do: "01"
  def transform_date("FEB"), do: "02"
  def transform_date("MAR"), do: "03"
  def transform_date("APR"), do: "04"
  def transform_date("MAY"), do: "05"
  def transform_date("JUN"), do: "06"
  def transform_date("JUL"), do: "07"
  def transform_date("AUG"), do: "08"
  def transform_date("SEP"), do: "09"
  def transform_date("OCT"), do: "10"
  def transform_date("NOV"), do: "11"
  def transform_date("DEC"), do: "12"
end
