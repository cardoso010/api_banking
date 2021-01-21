defmodule ApiBanking.AccountLogs.LoadersTest do
  use ApiBanking.DataCase, async: true

  alias ApiBanking.AccountLogs.Loader
  alias Ecto.UUID

  setup do
    user = insert(:user)
    account = insert(:account, user_id: user.id)
    account_log = insert(:account_log, origin_id: account.id)

    {:ok, %{user: user, account: account, account_log: account_log}}
  end

  describe "get!/1" do
    test "return account_log by uuid", %{account_log: account_log} do
      assert Loader.get!(account_log.id) == account_log
    end

    test "return nil when not exists" do
      assert_raise Ecto.NoResultsError, fn -> Loader.get!(UUID.generate()) end
    end
  end

  describe "all_by/1" do
    test "return users by origin", %{account: account, account_log: account_log} do
      assert Loader.all_by(%{origin_id: account.id}) == [account_log]
    end
  end
end
