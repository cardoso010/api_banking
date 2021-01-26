defmodule ApiBanking.Accounts.Loader do
  @moduledoc """
  Module to consult data from Account table
  """
  alias ApiBanking.{Account, Loaders.Commands, Repo}

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get(123)
      %Account{}

      iex> get(456)
      ** (Ecto.NoResultsError)

  """
  def get!(uuid) do
    Commands.get!(Account, uuid)
  end

  @doc """
  Gets a single account by user_id.

  ## Examples

      iex> get_by_user(123)
      %Account{}

      iex> get_by_user(:not_exist)
      nil

  """
  def get_by_user(user_id) do
    Repo.get_by(Account, user_id: user_id)
  end
end
