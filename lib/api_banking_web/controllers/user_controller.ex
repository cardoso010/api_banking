defmodule ApiBankingWeb.UserController do
  use ApiBankingWeb, :controller
  use PhoenixSwagger

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

  swagger_path :index do
    get("/api/v1/users")
    summary("Query for users")
    description("Query for users")
    produces("application/json")
    tag("Users")

    security([%{Bearer: []}])

    response(200, "OK", Schema.ref(:Users))
    response(400, "Client Error")
  end

  swagger_path :show do
    get("/api/v1/users/{id}")
    summary("Get user")
    description("Get user")
    produces("application/json")
    tag("Users")

    parameters do
      id(:path, :string, "User id",
        required: true,
        example: "fd6dea88-ad6d-4bd9-a63b-3e9086468a50"
      )
    end

    security([%{Bearer: []}])

    response(200, "OK", Schema.ref(:User))
    response(400, "Client Error")
  end

  swagger_path :update do
    put("/api/v1/users/{user_id}")
    summary("Update user")
    description("Update user")
    produces("application/json")
    tag("Users")

    parameters do
      user_id(:path, :string, "User name",
        required: true,
        example: "Gabriel"
      )

      name(:query, :string, "User name",
        required: true,
        example: "Gabriel"
      )

      email(:query, :string, "User email",
        required: true,
        example: "gabriel@test.com"
      )

      password(:query, :string, "User password",
        required: true,
        example: "gabriel123"
      )

      password_confirmation(:query, :string, "User password confirmation",
        required: true,
        example: "gabriel123"
      )
    end

    security([%{Bearer: []}])

    response(200, "OK", Schema.ref(:User))
    response(400, "Client Error")
  end

  swagger_path :create do
    post("/api/v1/users")
    summary("Create user")
    description("Create user")
    produces("application/json")
    tag("Users")

    parameters do
      name(:query, :string, "User name",
        required: true,
        example: "Gabriel"
      )

      email(:query, :string, "User email",
        required: true,
        example: "gabriel@test.com"
      )

      password(:query, :string, "User password",
        required: true,
        example: "gabriel123"
      )

      password_confirmation(:query, :string, "User password confirmation",
        required: true,
        example: "gabriel123"
      )
    end

    response(200, "OK", Schema.ref(:User))
    response(400, "Client Error")
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/v1/users/{id}")
    summary("Delete User")
    description("Delete a user by ID")
    tag("Users")
    parameter(:id, :path, :integer, "User ID", required: true, example: 3)
    security([%{Bearer: []}])
    response(203, "No Content - Deleted Successfully")
  end

  def swagger_definitions do
    %{
      User:
        swagger_schema do
          title("User")
          description("A user of the application")

          properties do
            id(:string, "Unique identifier", required: true)
            name(:string, "Users name", required: true)
            email(:string, "Users email", required: true)
            amount(:float, "User amount")
          end

          example(%{
            id: "123",
            name: "Joe",
            email: "joe@test.com"
          })
        end,
      Users:
        swagger_schema do
          title("Users")
          description("A collection of Users")
          type(:array)
          items(Schema.ref(:User))
        end
    }
  end
end
