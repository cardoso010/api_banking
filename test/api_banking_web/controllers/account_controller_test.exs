defmodule ApiBankingWeb.AccountControllerTest do
  use ApiBankingWeb.ConnCase, async: true

  alias ApiBanking.Auth.Guardian
  alias Ecto.UUID

  describe "withdraw" do
    setup %{conn: conn} do
      user = insert(:user)
      insert(:account, user_id: user.id)

      {:ok, token, _} = Guardian.encode_and_sign(user, %{}, token_type: :access)

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer " <> token)

      {:ok, conn: conn, user: user}
    end

    test "withdraw from user's  account", %{conn: conn, user: %{id: id}} do
      attrs = %{user_id: id, amount: 500}
      conn = put(conn, Routes.account_path(conn, :withdraw), attrs)

      assert %{"user_id" => ^id, "amount" => 500.0} = json_response(conn, 200)
    end

    test "withdraw from user non-existent", %{conn: conn} do
      attrs = %{user_id: UUID.generate(), amount: 500}
      conn = put(conn, Routes.account_path(conn, :withdraw), attrs)

      assert %{"error" => "User non-existent"} = json_response(conn, 400)
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

  describe "transfer" do
    setup %{conn: conn} do
      user_origin = insert(:user)
      insert(:account, user_id: user_origin.id)

      %{id: user_destiny_id} = insert(:user, email: "destiny.test@test.com")
      insert(:account, user_id: user_destiny_id)

      {:ok, token, _} = Guardian.encode_and_sign(user_origin, %{}, token_type: :access)

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer " <> token)

      {:ok, conn: conn, user_origin_id: user_origin.id, user_destiny_id: user_destiny_id}
    end

    test "transfer betweem user's account", %{
      conn: conn,
      user_origin_id: user_origin_id,
      user_destiny_id: user_destiny_id
    } do
      attrs = %{
        "sender_id" => user_origin_id,
        "receiver_id" => user_destiny_id,
        "amount" => 500
      }

      conn = put(conn, Routes.account_path(conn, :transfer), attrs)

      assert %{
               "sender_id" => ^user_origin_id,
               "receiver_id" => ^user_destiny_id,
               "amount" => 500
             } = json_response(conn, 200)
    end

    test "transfer from user non-existent", %{conn: conn} do
      attrs = %{
        "sender_id" => UUID.generate(),
        "receiver_id" => UUID.generate(),
        "amount" => 500
      }

      conn = put(conn, Routes.account_path(conn, :transfer), attrs)

      assert %{"error" => "User non-existent"} = json_response(conn, 400)
    end

    test "transfer with value higher", %{
      conn: conn,
      user_origin_id: user_origin_id,
      user_destiny_id: user_destiny_id
    } do
      attrs = %{
        "sender_id" => user_origin_id,
        "receiver_id" => user_destiny_id,
        "amount" => 2000
      }

      conn = put(conn, Routes.account_path(conn, :transfer), attrs)

      assert %{"error" => "Value is more than your amount"} = json_response(conn, 400)
    end

    test "transfer with wrong value", %{conn: conn} do
      attrs = %{
        "sender_id" => nil,
        "receiver_id" => nil,
        "amount" => nil
      }

      conn = put(conn, Routes.account_path(conn, :transfer), attrs)

      assert %{"error" => "Invalid type of data"} = json_response(conn, 400)
    end
  end

  describe "backoffice" do
    setup %{conn: conn} do
      user = insert(:user)
      account = insert(:account, user_id: user.id)
      insert(:account_log, origin_id: account.id)
      insert(:account_log, origin_id: account.id)
      insert(:account_log, origin_id: account.id)

      {:ok, token, _} = Guardian.encode_and_sign(user, %{}, token_type: :access)

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer " <> token)

      {:ok, conn: conn, user: user}
    end

    test "get report by day", %{conn: conn} do
      today = Timex.now()

      attrs = %{
        year: today.year,
        month: today.month,
        day: today.day
      }

      conn = get(conn, Routes.account_path(conn, :backoffice), attrs)

      assert %{"total per day" => 1.5e3} = json_response(conn, 200)
    end

    test "get report by month", %{conn: conn} do
      today = Timex.now()
      attrs = %{year: today.year, month: today.month}
      conn = get(conn, Routes.account_path(conn, :backoffice), attrs)

      assert %{"total per month" => 1.5e3} = json_response(conn, 200)
    end

    test "get report by year", %{conn: conn} do
      today = Timex.now()
      attrs = %{year: today.year}
      conn = get(conn, Routes.account_path(conn, :backoffice), attrs)

      assert %{"total per year" => 1.5e3} = json_response(conn, 200)
    end
  end
end
