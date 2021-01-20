defmodule ApiBanking.Users.MutatorTest do
  use ApiBanking.DataCase, async: true

  alias ApiBanking.User
  alias ApiBanking.Users.{Loader, Mutator}

  @valid_attrs %{email: "some@email.com", name: "some name", password: "some password"}
  @update_attrs %{
    email: "someupdated@email.com",
    name: "some updated name",
    password: "some updated password"
  }
  @invalid_attrs %{email: nil, name: nil, password: nil}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Mutator.create()

    user
  end

  def user_without_password(attrs \\ %{}) do
    %{user_fixture(attrs) | password: nil}
  end

  describe "create/1" do
    test "create/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Mutator.create(@valid_attrs)
      assert user.email == "some@email.com"
      assert user.name == "some name"
      assert Argon2.verify_pass("some password", user.password_hash)
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Mutator.create(@invalid_attrs)
    end
  end

  describe "update/2" do
    test "update/2 with valid data updates the user" do
      user = user_without_password()
      assert {:ok, %User{} = user} = Mutator.update(user, @update_attrs)
      assert user.email == "someupdated@email.com"
      assert user.name == "some updated name"
      assert Argon2.verify_pass("some updated password", user.password_hash)
    end

    test "update/2 with invalid data returns error changeset" do
      user = user_without_password()
      assert {:error, %Ecto.Changeset{}} = Mutator.update(user, @invalid_attrs)
      assert user == Loader.get!(user.id)
    end
  end

  describe "delete/1" do
    test "delete/1 deletes the user" do
      user = user_without_password()
      assert {:ok, %User{}} = Mutator.delete(user)
      assert_raise Ecto.NoResultsError, fn -> Loader.get!(user.id) end
    end
  end

  describe "change_user/1" do
    test "change_user/1 returns a user changeset" do
      user = user_without_password()
      assert %Ecto.Changeset{} = Mutator.change_user(user)
    end
  end
end
