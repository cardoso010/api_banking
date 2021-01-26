defmodule ApiBankingWeb.Router do
  use ApiBankingWeb, :router

  alias ApiBanking.Auth.Guardian

  pipeline :api do
    plug CORSPlug, origin: "*"
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/api/v1", ApiBankingWeb do
    pipe_through :api

    post "/users", UserController, :create
    post "/auth/sign_in", AuthController, :sign_in
  end

  scope "/api/v1", ApiBankingWeb do
    pipe_through [:api, :jwt_authenticated]

    resources "/users", UserController, except: [:create, :new, :edit]
    put "/accounts/withdraw", AccountController, :withdraw
    put "/accounts/transfer", AccountController, :transfer
    get "/accounts/backoffice", AccountController, :backoffice
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :api_banking,
      swagger_file: "swagger.json"
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: ApiBankingWeb.Telemetry
    end
  end

  def swagger_info do
    %{
      schemes: ["https", "http"],
      info: %{
        version: "1.0",
        title: "Api Banking",
        description: "API Documentation for Api Banking v1"
      },
      securityDefinitions: %{
        Bearer: %{
          type: "apiKey",
          name: "Authorization",
          description: "API Token must be provided via `Authorization: Bearer ` header",
          in: "header"
        },
        consumes: ["application/json"],
        produces: ["application/json"],
        tags: [
          %{name: "Users", description: "User resources"},
          %{name: "Accounts", description: "Account resources"},
          %{name: "Auths", description: "Auth resources"}
        ]
      }
    }
  end
end
