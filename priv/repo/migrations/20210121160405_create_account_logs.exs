defmodule ApiBanking.Repo.Migrations.CreateAccountLogs do
  use Ecto.Migration

  def change do
    MovimentType.create_type()
    create table(:account_logs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :movement_type, :moviment_type, null: false
      add :amount, :float, null: false
      add :sender_id, references(:users, on_delete: :nothing, type: :binary_id), null: true
      add :receiver_id, references(:users, on_delete: :nothing, type: :binary_id), null: true

      timestamps()
    end

    create index(:account_logs, [:sender_id])
    create index(:account_logs, [:receiver_id])
  end
end
