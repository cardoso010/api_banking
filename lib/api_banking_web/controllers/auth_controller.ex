defmodule ApiBankingWeb.AuthController do
  use ApiBankingWeb, :controller
  use PhoenixSwagger

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

  swagger_path :sign_in do
    post("/api/v1/auth/sign_in")
    summary("Login")
    description("Login")
    tag("Auths")

    parameters do
      email(:query, :string, "Email",
        required: true,
        example: "adm@admin.com"
      )

      password(:query, :string, "Password",
        required: true,
        example: "admin"
      )
    end

    response(200, "Success")
    response(400, "Client Error")
  end
end
