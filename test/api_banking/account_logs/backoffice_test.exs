defmodule ApiBanking.AccountLogs.BackofficeTest do
  use ApiBanking.DataCase, async: true

  alias ApiBanking.AccountLogs.Backoffice

  setup do
    user = insert(:user)
    account = insert(:account, user_id: user.id)
    account_log = insert(:account_log, origin_id: account.id)

    {:ok, %{user: user, account: account, account_log: account_log}}
  end

  describe "report/3" do
    test "return transactions's total of day", %{account: account} do
      insert(:account_log, origin_id: account.id)
      today = Timex.now()

      assert {:ok, %{"total per day" => 1.0e3}} =
               Backoffice.report(today.year, today.month, today.day)
    end

    test "return transactions's total of month", %{account: account} do
      insert(:account_log, origin_id: account.id)
      today = Timex.now()

      assert {:ok, %{"total per month" => 1.0e3}} =
               Backoffice.report(today.year, today.month, nil)
    end

    test "return transactions's total of year", %{account: account} do
      insert(:account_log, origin_id: account.id)
      today = Timex.now()
      assert {:ok, %{"total per year" => 1.0e3}} = Backoffice.report(today.year, nil, nil)
    end

    test "return transactions's total", %{account: account} do
      insert(:account_log, origin_id: account.id)
      assert {:ok, %{"total" => 1.0e3}} = Backoffice.report(nil, nil, nil)
    end
  end
end
