defmodule ApiBanking.Accounts.Mutator do
  alias ApiBanking.{Account, Repo, User}

  @doc """
  Creates a account with assoc to user.

  ## Examples

      iex> create_with_assoc(user)
      %Account{}

  """
  def create_with_assoc(%User{} = user) do
    user
    |> Ecto.build_assoc(:account, %{})
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Account{} = account, %{} = attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account(%Account{} = account, attrs \\ %{}) do
    account
    |> Account.changeset(attrs)
  end
end
