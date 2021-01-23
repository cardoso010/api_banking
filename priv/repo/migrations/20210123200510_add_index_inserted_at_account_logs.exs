defmodule ApiBanking.Repo.Migrations.AddIndexInsertedAtAccountLogs do
  use Ecto.Migration

  def change do
    create index(:account_logs, [:inserted_at])
  end
end
