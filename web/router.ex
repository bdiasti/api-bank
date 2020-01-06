defmodule ApiBank.Router do
  use ApiBank.Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :jwt_authenticated do
    plug(ApiBank.Guardian.AuthPipeline)
  end

  scope "/", ApiBank do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/api/v1", ApiBank do
    pipe_through(:api)

    post("/sign_in", UserController, :sign_in)
    post("/sign_up/", UserController, :create)
  end

  scope "/api/swagger" do
    forward("/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :api_bank, swagger_file: "swagger.json")
  end

  scope "/api/v1", ApiBank do
    pipe_through([:api, :jwt_authenticated])

    # Users
    get("/users", UserController, :index)
    get("/users/:id", UserController, :show)

    # Account
    get("/accounts", AccountController, :index)
    get("/accounts/:id", AccountController, :show)
    post("/accounts/", AccountController, :create)

    # Withdraw
    get("/withdraw/:id", WithdrawController, :show)
    post("/withdraw/", WithdrawController, :create)

    # Transfer
    get("/transfer/:id", TransferController, :show)
    post("/transfer/", TransferController, :create)

    # Report
    get("/report/day/:day/:month/:year", ReportController, :transaction_day)
    get("/report/month/:month/:year", ReportController, :transaction_month)
    get("/report/total/", ReportController, :transaction_total)
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Api bank APP"
      }
    }
  end
end
