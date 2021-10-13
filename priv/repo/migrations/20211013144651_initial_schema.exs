defmodule Budgetalx.Repo.Migrations.InitialSchema do
  use Ecto.Migration
  import Budgetalx.Migration

  def up do
    exec_file("initial_schema_up.sql")
  end

  def down do
    exec_file("initial_schema_down.sql")
  end

  def exec_file(file) do
    "priv/repo/migrations"
    |> Path.join(file)
    |> File.read!()
    |> execute_sql()
  end
end
