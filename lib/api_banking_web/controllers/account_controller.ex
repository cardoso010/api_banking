defmodule ApiBankingWeb.AccountController do
  use ApiBankingWeb, :controller

  alias ApiBanking.Accounts.Withdraw

  action_fallback ApiBankingWeb.FallbackController

  def withdraw(conn, %{"user_id" => user_id, "amount" => amount}) do
    case Withdraw.withdraw(user_id, amount) do
      {:ok, account} ->
        conn |> render("account.json", account: account)

      _ = error ->
        error
    end
  end
end
