defmodule ApiBankingWeb.UserController do
  use ApiBankingWeb, :controller

  alias ApiBanking.{Account, User, Users.Loader, Users.Mutator}
  alias ApiBanking.Accounts.Mutator, as: AccountMutator

  action_fallback ApiBankingWeb.FallbackController

  def index(conn, _params) do
    users = Loader.all()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Mutator.create(user_params),
         {:ok, %Account{}} <- AccountMutator.create_with_assoc(user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Loader.get_with_account(id)
    render(conn, "show_with_amount.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Loader.get!(id)

    with {:ok, %User{} = user} <- Mutator.update(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Loader.get!(id)

    with {:ok, %User{}} <- Mutator.delete(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
