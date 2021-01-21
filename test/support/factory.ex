defmodule ApiBanking.Factory do
  use ExMachina.Ecto, repo: ApiBanking.Repo

  use ApiBanking.UserFactory
  use ApiBanking.AccountFactory

  def id, do: Ecto.UUID.generate()
end
