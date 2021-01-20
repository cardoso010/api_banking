defmodule ApiBanking.Auth do
  alias ApiBanking.{Auth.Guardian, Repo, User}
  import Argon2, only: [check_pass: 2]
  require IEx

  def token_sign_in(email, password) do
    case email_password_auth(email, password) do
      {:ok, user} ->
        Guardian.encode_and_sign(user)

      _ ->
        {:error, :unauthorized}
    end
  end

  defp email_password_auth(email, password) when is_binary(email) and is_binary(password) do
    with {:ok, user} <- get_by_email(email),
         do: verify_password(password, user)
  end

  defp get_by_email(email) when is_binary(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        Bcrypt.no_user_verify()
        {:error, "Login error."}

      user ->
        {:ok, user}
    end
  end

  defp verify_password(password, %User{} = user) when is_binary(password) do
    case check_pass(user, password) do
      {:ok, %User{}} = user -> user
      _ -> {:error, :invalid_password}
    end
  end
end
