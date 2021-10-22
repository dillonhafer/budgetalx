defmodule Budgetalx.Migration do
  use Ecto.Migration

  def execute_sql(sql_statements) do
    sql_statements
    |> String.split(";")
    |> Enum.filter(fn s -> String.trim(s) != "" end)
    |> Enum.each(&execute/1)
  end

  def exec_file(file) do
    "priv/repo/migrations"
    |> Path.join(file)
    |> File.read!()
    |> execute_sql()
  end
end
