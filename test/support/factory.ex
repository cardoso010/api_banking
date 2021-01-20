defmodule ApiBanking.Factory do
  use ExMachina.Ecto, repo: ApiBanking.Repo

  use ApiBanking.UserFactory

  def id, do: Ecto.UUID.generate()
end
