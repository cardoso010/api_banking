defmodule ApiBanking.Loaders.CommandsTest do
  use ApiBanking.DataCase, async: true

  alias ApiBanking.Loaders.Commands
  alias ApiBanking.User
  alias Ecto.Query

  describe "get/1" do
    test "when uuid is valid returns corresponding entity" do
      user = insert(:user) |> reset_password

      assert Commands.get(User, user.id) == user
    end

    test "when uuid is invalid return error tuple" do
      assert Commands.get(User, "user-uuid") == {:error, "invalid UUID"}
    end
  end

  describe "all_by_filters/2" do
    test "return a correct Ecto Query with one where" do
      filters = %{email: "test@test.com"}

      response = Commands.all_by_filters(User, filters)

      assert %Query{} = response

      assert inspect(response) ==
               "#Ecto.Query<from u0 in ApiBanking.User, where: u0.email == ^\"test@test.com\">"
    end

    test "return a correct Ecto Query with more than one where" do
      filters = %{email: "someid", name: "somenumber"}

      response = Commands.all_by_filters(User, filters)

      assert %Query{} = response

      assert inspect(response) ==
               "#Ecto.Query<from u0 in ApiBanking.User, where: u0.email == ^\"someid\", where: u0.name == ^\"somenumber\">"
    end

    test "when filter by has a nil value" do
      filters = %{key: nil}

      response = Commands.all_by_filters(User, filters)

      assert %Query{} = response

      assert inspect(response) ==
               "#Ecto.Query<from u0 in ApiBanking.User, where: is_nil(u0.key)>"
    end

    test "when filter has especific operator" do
      filters = %{
        key_one: {:!=, 1},
        key_two: {:<=, 2},
        key_three: {:>=, 3},
        key_four: {:<, 4},
        key_five: {:>, 5}
      }

      response = Commands.all_by_filters(User, filters)

      assert %Query{} = response

      assert inspect(response) ==
               "#Ecto.Query<from u0 in ApiBanking.User, where: u0.key_five > ^5, where: u0.key_four < ^4, where: u0.key_one != ^1, where: u0.key_three >= ^3, where: u0.key_two <= ^2>"
    end
  end

  defp reset_password(user) do
    %{user | password: nil, password_confirmation: nil}
  end
end
