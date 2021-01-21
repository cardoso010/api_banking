defmodule ApiBanking.Repo.Migrations.CreateAccountLogs do
  use Ecto.Migration

  def change do
    MovimentType.create_type()
    create table(:account_logs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :movement_type, :moviment_type, null: false
      add :amount, :float, null: false
      add :origin_id, references(:accounts, on_delete: :nothing, type: :binary_id), null: false
      add :destiny_id, references(:accounts, on_delete: :nothing, type: :binary_id), null: true

      timestamps()
    end

    create index(:account_logs, [:origin_id])
    create index(:account_logs, [:destiny_id])
  end
end
