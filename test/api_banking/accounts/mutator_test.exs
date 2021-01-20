defmodule ApiBanking.Accounts.MutatorTest do
  use ApiBanking.DataCase, async: true

  alias ApiBanking.Account
  alias ApiBanking.Accounts.{Mutator}

  describe "create_with_assoc/1" do
    test "create_with_assoc/1 with valid data" do
      user = insert(:user)
      {:ok, %Account{} = account} = Mutator.create_with_assoc(user)
      assert account.user_id == user.id
      assert account.amount == 1000
    end
  end
end
