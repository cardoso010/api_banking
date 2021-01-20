defmodule ApiBanking.Auth.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :api_banking,
    module: ApiBanking.Auth.Guardian,
    error_handler: ApiBanking.Auth.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
