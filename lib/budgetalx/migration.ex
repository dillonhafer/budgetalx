defmodule Budgetalx.Migration do
  use Ecto.Migration

  def execute_sql(sql_statements) do
    sql_statements
    |> String.split(";")
    |> Enum.filter(fn s -> String.trim(s) != "" end)
    |> Enum.each(&execute/1)
  end
end
