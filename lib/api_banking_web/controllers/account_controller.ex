defmodule ApiBankingWeb.AccountController do
  use ApiBankingWeb, :controller

  alias ApiBanking.AccountLogs.Backoffice
  alias ApiBanking.Accounts.{Transfer, Withdraw}

  require IEx

  action_fallback ApiBankingWeb.FallbackController

  def withdraw(conn, %{"user_id" => user_id, "amount" => amount}) do
    case Withdraw.withdraw(user_id, amount) do
      {:ok, account} ->
        conn |> render("withdraw.json", account: account)

      _ = error ->
        error
    end
  end

  def transfer(conn, %{"sender_id" => sender_id, "receiver_id" => receiver_id, "amount" => amount}) do
    case Transfer.transfer(sender_id, receiver_id, amount) do
      :ok ->
        conn
        |> render("transfer.json",
          transfer: %{sender_id: sender_id, receiver_id: receiver_id, amount: amount}
        )

      _ = error ->
        error
    end
  end

  def backoffice(conn, _params) do
    {:ok, body, _conn} = Plug.Conn.read_body(conn)
    data = Jason.decode!(body)

    case Backoffice.report(data["year"], data["month"], data["day"]) do
      {:ok, data} ->
        conn
        |> json(data)

      _ = error ->
        error
    end
  end
end
