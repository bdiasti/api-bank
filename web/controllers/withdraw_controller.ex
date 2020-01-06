defmodule ApiBank.WithdrawController do
  use ApiBank.Web, :controller
  use PhoenixSwagger

  alias ApiBank.Withdraw
  alias ApiBank.Account
  alias ApiBank.WithdrawService
  alias ApiBank.AccountService

  action_fallback(ApiBank.FallbackController)

  swagger_path :show do
    get("/api/v1/withdraw/{id}")
    summary("Query withdraw by id")
    produces("application/json")
    parameter("Authorization", :header, :string, "JWT access token", required: true)
    tag("Withdraw")
    description("Search Withdraw")
    response(200, "OK")

    parameters do
      id(:path, :string, "id withdraw")
    end
  end

  def show(conn, %{"id" => id}) do
    withdraw = WithdrawService.get_withdraw!(id)
    json(conn, withdraw)
  end

  swagger_path :create do
    post("/api/v1/withdraw/")
    summary("Create withdraw")
    produces("application/json")
    parameter("Authorization", :header, :string, "JWT access token", required: true)
    tag("Withdraw")
    description("Create Withdraw")
    response(200, "OK")

    parameters do
      transfer(:body, Schema.ref(:Withdraw), "withdraw atributes")
    end
  end

  def create(conn, %{"account_source" => account_source, "value" => value}) do
    with {:ok, %Account{} = account_source} <- AccountService.get_account!(account_source) do
      case value <= account_source.value do
        true ->
          AccountService.decrease_value(account_source, value)
          WithdrawService.create_withdraw(%{"account_id" => account_source.id, "value" => value})
          # Send e-mail for user
          json(conn |> put_status(:created), :ok)
      end
    end
  end

  def swagger_definitions do
    %{
      Withdraw:
        swagger_schema do
          title("Withdraw")
          description("A Withdraw of the application")

          properties do
            account_source(:string, "Account source", required: true)
            value(:integer, "must have sufficient balance for withdraw ", required: true)
          end

          example(%{
            account_source: "id account source",
            value: 983
          })
        end
    }
  end
end
