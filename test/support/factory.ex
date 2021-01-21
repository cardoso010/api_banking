defmodule ApiBanking.Factory do
  use ExMachina.Ecto, repo: ApiBanking.Repo

  use ApiBanking.UserFactory
  use ApiBanking.AccountFactory
  use ApiBanking.AccountLogFactory

  def id, do: Ecto.UUID.generate()
end
