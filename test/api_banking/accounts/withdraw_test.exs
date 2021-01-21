defmodule ApiBanking.Accounts.WithdrawTest do
  use ApiBanking.DataCase, async: true

  alias ApiBanking.{Account, Accounts.Withdraw}

  setup do
    user = insert(:user)
    account = insert(:account, user_id: user.id)

    {:ok, %{user: user, account: account}}
  end

  describe "withdraw/2" do
    test "to do a withdraw from user's account", %{user: user} do
      withdraw_return = Withdraw.withdraw(user.id, 500)
      assert {:ok, %Account{} = account} = withdraw_return
      assert account.amount == 500
    end

    test "pass a higher value", %{user: user} do
      assert {:error, "Value is more than your amount"} = Withdraw.withdraw(user.id, 2000)
    end

    test "pass wrong value", %{user: user} do
      assert {:error, "Invalid type of data"} = Withdraw.withdraw(user.id, nil)
    end
  end

  describe "validate_amount/2" do
    test "to do a withdraw from user's account", %{account: account} do
      assert {:ok, %Account{}, 500} = Withdraw.validate_amount(account, 500)
    end

    test "pass a higher value", %{account: account} do
      assert {:error, "Value is more than your amount"} = Withdraw.validate_amount(account, 2000)
    end
  end

  describe "withdraw_from_account/2" do
    test "to do a withdraw from user's account", %{account: account} do
      assert {:ok, %Account{}, 500} = Withdraw.validate_amount(account, 500)
    end

    test "pass a higher value", %{account: account} do
      assert {:error, "Value is more than your amount"} = Withdraw.validate_amount(account, 2000)
    end
  end
end
