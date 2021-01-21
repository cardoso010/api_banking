defmodule ApiBanking.AccountLogs.MutatorTest do
  use ApiBanking.DataCase, async: true

  alias ApiBanking.AccountLog
  alias ApiBanking.AccountLogs.Mutator

  setup do
    user = insert(:user)
    account = insert(:account, user_id: user.id)

    {:ok, %{user: user, account: account}}
  end

  describe "create_withdraw/2" do
    test "create a valid log", %{
      account: account
    } do
      assert {:ok, %AccountLog{} = account_log} = Mutator.create_withdraw(account.id, 500)
      assert account.id == account_log.origin_id
      assert account_log.amount == 500
      assert account_log.movement_type == :withdraw
    end

    test "try create with a invalid data", %{
      account: account
    } do
      assert {:error, "Invalid type of data"} = Mutator.create_withdraw(account.id, nil)
    end
  end

  describe "create_transfer/3" do
    test "create a valid log", %{
      account: account_origin
    } do
      %{id: destiny_user_id} = insert(:user, email: "test@testedestiny.com")
      %{id: destiny_account_id} = insert(:account, user_id: destiny_user_id)

      assert {:ok, %AccountLog{} = account_log} =
               Mutator.create_transfer(account_origin.id, destiny_account_id, 500)

      assert account_log.movement_type == :transfer
      assert account_log.amount == 500
      assert account_origin.id == account_log.origin_id
      assert destiny_account_id == account_log.destiny_id
    end

    test "try create with a invalid data" do
      assert {:error, "Invalid type of data"} = Mutator.create_transfer(nil, nil, nil)
    end
  end

  describe "create/1" do
    test "create a log of withdraw with valid", %{
      account: account
    } do
      data = %{movement_type: :withdraw, amount: 500, origin_id: account.id}
      assert {:ok, %AccountLog{} = account_log} = Mutator.create(data)
      assert account.id == account_log.origin_id
      assert account_log.amount == 500
    end

    test "create a log of transfer with valid", %{
      account: account_origin
    } do
      %{id: user_destiny_id} = insert(:user, email: "destiny@teste.com")
      %{id: account_destiny_id} = insert(:account, user_id: user_destiny_id)

      data = %{
        movement_type: :transfer,
        amount: 500,
        origin_id: account_origin.id,
        destiny_id: account_destiny_id
      }

      assert {:ok, %AccountLog{} = account_log} = Mutator.create(data)
      assert account_log.movement_type == :transfer
      assert account_log.amount == 500
      assert account_origin.id == account_log.origin_id
      assert account_destiny_id == account_log.destiny_id
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Mutator.create(%{})
    end
  end
end
