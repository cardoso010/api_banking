defmodule ApiBanking.Accounts.Mutator do
  alias ApiBanking.{Repo, User}

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
end
