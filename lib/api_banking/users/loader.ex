defmodule ApiBanking.Users.Loader do
  alias ApiBanking.{User, Loaders.Commands, Repo}

  def get(uuid) do
    Commands.get(User, uuid)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get(123)
      %User{}

      iex> get(456)
      ** (Ecto.NoResultsError)

  """
  def get!(uuid) do
    Commands.get!(User, uuid)
  end

  @doc """
  Returns the list of users

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def all do
    User
    |> Repo.all()
  end

  @doc """
  Returns the list of users by filters.

  ## Examples

      iex> list_users(%{email: "teste@teste.com"})
      [%User{}, ...]

  """
  def all_by(filters) do
    User
    |> Commands.all_by_filters(filters)
    |> Repo.all()
  end
end
