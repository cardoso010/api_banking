defmodule ApiBanking.Accounts.AccountRulesTest do
  use ApiBanking.DataCase, async: true

  alias ApiBanking.{Account, Accounts.AccountRules}

  setup do
    user = insert(:user)
    account = insert(:account, user_id: user.id)

    {:ok, %{user: user, account: account}}
  end

  describe "validate_amount/2" do
    test "to do a withdraw from user's account", %{account: account} do
      assert {:ok, %Account{}, 500} = AccountRules.validate_amount(account, 500)
    end

    test "pass a higher value", %{account: account} do
      assert {:error, "Value is more than your amount"} =
               AccountRules.validate_amount(account, 2000)
    end
  end
end
