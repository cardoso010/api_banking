defmodule ApiBanking.Accounts.TransferTest do
  use ApiBanking.DataCase, async: true

  alias ApiBanking.{Accounts.Loader, Accounts.Transfer}

  setup do
    %{id: user_origin_id} = insert(:user)
    origin = insert(:account, user_id: user_origin_id)

    %{id: user_destiny_id} = insert(:user, email: "destiny@test.com")
    destiny = insert(:account, user_id: user_destiny_id)

    {:ok, %{origin: origin, destiny: destiny}}
  end

  describe "transfer/3" do
    test "to do a transfer between user's account", %{origin: origin, destiny: destiny} do
      assert :ok = Transfer.transfer(origin.user_id, destiny.user_id, 500)

      origin_new = Loader.get_by_user(origin.user_id)
      destiny_new = Loader.get_by_user(destiny.user_id)

      new_amount_origin = origin.amount - 500
      new_amount_destiny = destiny.amount + 500

      assert new_amount_origin == origin_new.amount
      assert new_amount_destiny == destiny_new.amount
    end

    test "pass a higher value", %{origin: origin, destiny: destiny} do
      assert {:error, "Value is more than your amount"} =
               Transfer.transfer(origin.user_id, destiny.user_id, 2000)
    end

    test "pass wrong value" do
      assert {:error, "Invalid type of data"} = Transfer.transfer(nil, nil, nil)
    end
  end
end
