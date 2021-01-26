defmodule ApiBankingWeb.AccountController do
  use ApiBankingWeb, :controller
  use PhoenixSwagger

  alias ApiBanking.AccountLogs.Backoffice
  alias ApiBanking.Accounts.{Transfer, Withdraw}

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

  def backoffice(conn, params) do
    {:ok, body, _conn} = Plug.Conn.read_body(conn)
    data = get_body(params, body)

    case Backoffice.report(
           convert_to_integer(data["year"]),
           convert_to_integer(data["month"]),
           convert_to_integer(data["day"])
         ) do
      {:ok, data} ->
        conn
        |> json(data)

      _ = error ->
        error
    end
  end

  defp get_body(params, body) do
    if String.length(body) > 0 and params == %{} do
      Jason.decode!(body)
    else
      params
    end
  end

  defp convert_to_integer(value) when is_binary(value), do: String.to_integer(value)
  defp convert_to_integer(value), do: value

  swagger_path :withdraw do
    put("/api/v1/accounts/withdraw")
    description("Withdraw between accounts")
    tag("Accounts")

    parameters do
      user_id(:query, :string, "User id",
        required: true,
        example: "fd6dea88-ad6d-4bd9-a63b-3e9086468a50"
      )

      amount(:query, :float, "Amount to withdraw from account",
        required: true,
        example: 500
      )
    end

    security([%{Bearer: []}])

    response(200, "Success")
    response(400, "Client Error")
  end

  swagger_path :transfer do
    put("/api/v1/accounts/transfer")
    description("Transfer between accounts")
    tag("Accounts")

    parameters do
      sender_id(:query, :string, "User id",
        required: true,
        example: "fd6dea88-ad6d-4bd9-a63b-3e9086468a50"
      )

      receiver_id(:query, :string, "User id",
        required: true,
        example: "fd6dea88-ad6d-4bd9-a63b-3e9086468a50"
      )

      amount(:query, :float, "Amount to withdraw from account",
        required: true,
        example: 500
      )
    end

    security([%{Bearer: []}])

    response(200, "Success")
    response(400, "Client Error")
  end

  swagger_path :backoffice do
    get("/api/v1/accounts/backoffice")
    description("Generate Backoffice")
    tag("Accounts")

    parameters do
      year(:query, :integer, "Year", example: 2020)

      month(:query, :integer, "Month", example: 02)

      day(:query, :integer, "Day", example: 02)
    end

    security([%{Bearer: []}])

    response(200, "Success")
    response(400, "Client Error")
  end
end
