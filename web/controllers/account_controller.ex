defmodule ApiBank.AccountController do
  use ApiBank.Web, :controller
  use PhoenixSwagger

  alias ApiBank.Account
  alias ApiBank.AccountService

  swagger_path :index do
    get("/api/v1/accounts")
    summary("Query for Accounts")
    produces("application/json")
    parameter("Authorization", :header, :string, "JWT access token", required: true)
    tag("Accounts")
    description("List all bank accounts")
    response(200, "OK")
  end

  def index(conn, _params) do
    accounts = AccountService.list_accounts()
    json(conn, accounts)
  end

  swagger_path :show do
    get("/api/v1/accounts/{id}")
    summary("Query account by id")
    produces("application/json")
    parameter("Authorization", :header, :string, "JWT access token", required: true)
    tag("Accounts")
    description("Search by Account id")
    response(200, "OK")

    parameters do
      id(:path, :string, "id account")
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Account{} = account} <- AccountService.get_account!(id) do
      json(conn, account)
    end
  end

  swagger_path :create do
    post("/api/v1/accounts/")
    summary("Create bank account")
    produces("application/json")
    parameter("Authorization", :header, :string, "JWT access token", required: true)
    tag("Accounts")
    description("Create bank account")
    response(200, "OK")

    parameters do
      account(:body, Schema.ref(:Account), "Account attributes")
    end
  end

  def create(conn, params) do
    with {:ok, %Account{} = account} <- AccountService.create_account(params) do
      json(conn, account)
    end
  end

  def swagger_definitions do
    %{
      Account:
        swagger_schema do
          title("Account")
          description("Account start with 1000 ammount")

          properties do
            user_id(:string, "User id", required: true)
          end

          example(%{
            user_id: "one user id"
          })
        end
    }
  end
end
