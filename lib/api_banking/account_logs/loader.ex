defmodule ApiBanking.AccountLogs.Loader do
  import Ecto.Query
  alias ApiBanking.{AccountLog, Loaders.Commands, Repo}

  @doc """
  Get total sum of (transactions) AccountLog between dates

  ## Examples

      iex> get_total_between_dates(~N[2021-02-15 14:38:32], ~N[2021-02-20 00:38:32])
      200

  """
  def get_total_between_dates(start_date, end_date) do
    [total] =
      from(p in AccountLog,
        where: fragment("inserted_at BETWEEN ? AND ?", ^start_date, ^end_date),
        select: sum(p.amount)
      )
      |> Repo.all()

    total
  end

  @doc """
  Get total sum of (transactions) AccountLog by day

  ## Examples

      iex> get_total_by_day("2021-02-15")
      200

  """
  def get_total_by_day(date) do
    [total] =
      from(a in AccountLog,
        where: fragment("date_trunc('day', ?)", a.inserted_at) == type(^date, :date),
        select: sum(a.amount)
      )
      |> Repo.all()

    total
  end

  @doc """
  Get total sum of (transactions) AccountLog
  """
  def get_total_sum do
    [total] =
      from(a in AccountLog, select: sum(a.amount))
      |> Repo.all()

    total
  end

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
