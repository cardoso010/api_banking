defmodule ApiBanking.AccountLogs.Mutator do
  alias ApiBanking.{AccountLog, Repo}

  @doc """
  Create a log to withdraw
  """
  def create_withdraw(origin_id, amount) when is_binary(origin_id) and is_number(amount) do
    create(%{origin_id: origin_id, amount: amount, movement_type: :withdraw})
  end

  def create_withdraw(_origin_id, _amount), do: {:error, "Invalid type of data"}

  @doc """
  Create a log to transfer
  """
  def create_transfer(origin_id, destiny_id, amount)
      when is_binary(origin_id) and is_binary(destiny_id) and is_number(amount) do
    create(%{
      origin_id: origin_id,
      destiny_id: destiny_id,
      amount: amount,
      movement_type: :transfer
    })
  end

  def create_transfer(_origin_id, _destiny_id, _amount), do: {:error, "Invalid type of data"}

  @doc """
  Creates a user.

  ## Examples

      iex> create(%{field: value})
      {:ok, %AccountLog{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(%{} = attrs) do
    %AccountLog{}
    |> AccountLog.changeset(attrs)
    |> Repo.insert()
  end
end
