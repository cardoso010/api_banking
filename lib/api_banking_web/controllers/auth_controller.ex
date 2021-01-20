defmodule ApiBankingWeb.AuthController do
  use ApiBankingWeb, :controller

  alias ApiBanking.Auth

  action_fallback ApiBankingWeb.FallbackController

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Auth.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        conn |> render("jwt.json", jwt: token)

      _ ->
        {:error, :unauthorized}
    end
  end
end
