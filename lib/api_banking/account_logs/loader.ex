defmodule ApiBanking.AccountLogs.Loader do
  alias ApiBanking.{AccountLog, Loaders.Commands, Repo}

  @doc """
  Gets a single account_log.

  Raises `Ecto.NoResultsError` if the AccountLog does not exist.

  ## Examples

      iex> get(123)
      %AccountLog{}

      iex> get(456)
      ** (Ecto.NoResultsError)

  """
  def get!(uuid) do
    Commands.get!(AccountLog, uuid)
  end

  @doc """
  Returns the list of account_logs by filters.

  ## Examples

      iex> all_by(%{sender_id: "1234131231"})
      [%AccountLog{}, ...]

  """
  def all_by(filters) do
    AccountLog
    |> Commands.all_by_filters(filters)
    |> Repo.all()
  end
end
