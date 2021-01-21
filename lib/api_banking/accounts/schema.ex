defmodule ApiBanking.Account do
  @moduledoc "Schema for account table"
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :amount, :float, default: 1000.00
    belongs_to :user, ApiBanking.User

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:amount, :user_id])
    |> validate_required([:amount, :user_id])
  end
end
