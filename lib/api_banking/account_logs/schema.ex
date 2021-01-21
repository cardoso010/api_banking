defmodule ApiBanking.AccountLog do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "account_logs" do
    field :movement_type, MovimentType, null: false
    field :amount, :float, null: false
    field :origin_id, :binary_id, null: false
    field :destiny_id, :binary_id, null: true

    timestamps()
  end

  @doc false
  def changeset(account_log, attrs) do
    account_log
    |> cast(attrs, [:movement_type, :amount, :origin_id, :destiny_id])
    |> validate_required([:movement_type, :amount, :origin_id])
  end
end
