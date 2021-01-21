defmodule ApiBanking.Accounts.MutatorTest do
  use ApiBanking.DataCase, async: true

  alias ApiBanking.Account
  alias ApiBanking.Accounts.{Loader, Mutator}

  describe "create_with_assoc/1" do
    test "create_with_assoc/1 with valid data" do
      user = insert(:user)
      {:ok, %Account{} = account} = Mutator.create_with_assoc(user)
      assert account.user_id == user.id
      assert account.amount == 1000
    end
  end

  describe "update/2" do
    test "update/2 with valid data updates the account" do
      user = insert(:user)
      account = insert(:account, user_id: user.id)
      assert {:ok, %Account{} = account} = Mutator.update(account, %{amount: 500})
      assert account.amount == 500
    end

    test "update/2 with invalid data returns error changeset" do
      user = insert(:user)
      account = insert(:account, user_id: user.id)

      assert {:error, %Ecto.Changeset{}} = Mutator.update(account, %{amount: nil})
      assert account == Loader.get!(account.id)
    end
  end

  describe "change_account/1" do
    test "change_account/1 returns a account changeset" do
      user = insert(:user)
      account = insert(:account, user_id: user.id)
      assert %Ecto.Changeset{} = Mutator.change_account(account)
    end
  end
end
