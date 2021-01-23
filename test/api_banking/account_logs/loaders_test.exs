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

  describe "get_total_sum" do
    test "return total of transactions", %{account: account} do
      insert(:account_log, origin_id: account.id)
      assert Loader.get_total_sum() == 1000
    end
  end

  describe "get_total_by_day" do
    test "return transactions's total of today", %{account: account} do
      insert(:account_log, origin_id: account.id)
      today = Timex.now() |> Timex.format!("{YYYY}-{0M}-{D}")
      assert Loader.get_total_by_day(today) == 1000
    end
  end

  describe "get_total_between_dates" do
    test "return transactions's total of between dates", %{account: account} do
      insert(:account_log, origin_id: account.id)
      start_date = Timex.beginning_of_month(Timex.now())
      end_date = Timex.end_of_month(Timex.now())
      assert Loader.get_total_between_dates(start_date, end_date) == 1000
    end
  end
end
