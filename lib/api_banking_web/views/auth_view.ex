defmodule ApiBankingWeb.AuthView do
  use ApiBankingWeb, :view

  def render("jwt.json", %{jwt: jwt}) do
    %{token: jwt}
  end
end
