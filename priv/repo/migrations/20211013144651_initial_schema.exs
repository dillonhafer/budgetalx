defmodule Budgetalx.Repo.Migrations.InitialSchema do
  use Ecto.Migration
  import Budgetalx.Migration

  def up do
    exec_file("initial_schema_up.sql")
  end

  def down do
    exec_file("initial_schema_down.sql")
  end
end
