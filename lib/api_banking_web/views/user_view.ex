defmodule ApiBankingWeb.UserView do
  use ApiBankingWeb, :view
  alias ApiBankingWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("show_with_amount.json", %{user: user}) do
    %{data: render_one(user, UserView, "user_with_amount.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, name: user.name, email: user.email}
  end

  def render("user_with_amount.json", %{user: user}) do
    %{id: user.id, name: user.name, email: user.email, amount: user.account.amount}
  end
end
