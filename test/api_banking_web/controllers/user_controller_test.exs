defmodule ApiBankingWeb.UserControllerTest do
  use ApiBankingWeb.ConnCase, async: true
  alias ApiBanking.Accounts.Mutator, as: AccountMutator
  alias ApiBanking.{Auth.Guardian, User, Users.Mutator}

  @create_attrs %{
    email: "some@email.com",
    name: "some name",
    password: "some password",
    password_confirmation: "some password"
  }
  @update_attrs %{
    email: "someupdated@email.com",
    name: "some updated name",
    password: "some updated password",
    password_confirmation: "some updated password"
  }
  @invalid_attrs %{email: nil, name: nil, password: nil, password_confirmation: nil}

  def fixture(:user) do
    {:ok, user} = Mutator.create(@create_attrs)
    AccountMutator.create_with_assoc(user)
    user
  end

  setup %{conn: conn} do
    user_auth = insert(:user)

    {:ok, token, _} = Guardian.encode_and_sign(user_auth, %{}, token_type: :access)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer " <> token)

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))

      assert is_list(json_response(conn, 200)["data"])
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "email" => "some@email.com",
               "name" => "some name",
               "amount" => 1.0e3
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{
      conn: conn,
      user: %User{id: id} = user
    } do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "email" => "someupdated@email.com",
               "name" => "some updated name",
               "amount" => 1.0e3
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    %{user: user}
  end
end
