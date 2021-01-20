defmodule ApiBanking.Users.LoadersTest do
  use ApiBanking.DataCase, async: true

  alias ApiBanking.Users.Loader
  alias Ecto.UUID

  describe "get!/1" do
    test "return user by uuid" do
      user_one = insert(:user) |> reset_password()

      assert Loader.get!(user_one.id) == user_one
    end

    test "return nil when not exists" do
      assert_raise Ecto.NoResultsError, fn -> Loader.get!(UUID.generate()) end
    end
  end

  describe "all_by/1" do
    test "return users by email" do
      user_one = insert(:user, email: "teste@teste.com") |> reset_password()

      assert Loader.all_by(%{email: "teste@teste.com"}) == [user_one]
    end
  end

  describe "all/0" do
    test "all/0 returns all users" do
      user_one = insert(:user) |> reset_password()

      assert Loader.all() == [user_one]
    end
  end

  defp reset_password(user) do
    %{user | password: nil}
  end
end
