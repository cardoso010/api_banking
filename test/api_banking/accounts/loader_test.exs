defmodule ApiBanking.Accounts.LoadersTest do
  use ApiBanking.DataCase, async: true

  alias ApiBanking.Accounts.Loader
  alias Ecto.UUID

  setup do
    user = insert(:user)
    account = insert(:account, user_id: user.id)

    {:ok, %{user: user, account: account}}
  end

  describe "get!/1" do
    test "return account by uuid", %{account: account} do
      assert Loader.get!(account.id) == account
    end

    test "return nil when not exists" do
      assert_raise Ecto.NoResultsError, fn -> Loader.get!(UUID.generate()) end
    end
  end

  describe "get_by_user/1" do
    test "return account by user_id", %{user: user, account: account} do
      assert Loader.get_by_user(user.id) == account
    end

    test "return nil when not exists" do
      assert Loader.get_by_user(UUID.generate()) == nil
    end
  end
end
