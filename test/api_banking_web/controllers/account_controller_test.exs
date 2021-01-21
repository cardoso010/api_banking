defmodule ApiBankingWeb.AccountControllerTest do
  use ApiBankingWeb.ConnCase, async: true

  alias ApiBanking.Auth.Guardian
  require IEx

  setup %{conn: conn} do
    user = insert(:user)
    account = insert(:account, user_id: user.id)

    {:ok, token, _} = Guardian.encode_and_sign(user, %{}, token_type: :access)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer " <> token)

    {:ok, conn: conn, user: user, account: account}
  end

  describe "withdraw" do
    test "withdraw from user's  account", %{conn: conn, user: %{id: id}} do
      attrs = %{user_id: id, amount: 500}
      conn = put(conn, Routes.account_path(conn, :withdraw), attrs)

      assert %{"user_id" => ^id, "amount" => 500.0} = json_response(conn, 200)
    end

    test "withdraw with value higher", %{conn: conn, user: %{id: id}} do
      attrs = %{user_id: id, amount: 2000}
      conn = put(conn, Routes.account_path(conn, :withdraw), attrs)

      assert %{"error" => "Value is more than your amount"} = json_response(conn, 400)
    end

    test "withdraw with wrong value", %{conn: conn, user: %{id: id}} do
      attrs = %{user_id: id, amount: nil}
      conn = put(conn, Routes.account_path(conn, :withdraw), attrs)

      assert %{"error" => "Invalid type of data"} = json_response(conn, 400)
    end
  end
end
