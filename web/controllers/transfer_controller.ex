defmodule ApiBank.TransferController do
  use ApiBank.Web, :controller
  use PhoenixSwagger

  alias ApiBank.Transfer
  alias ApiBank.Account
  alias ApiBank.TransferService
  alias ApiBank.AccountService

  swagger_path :show do
    get("/api/v1/transfer/{id}")
    summary("Query transfer by id")
    produces("application/json")
    parameter("Authorization", :header, :string, "JWT access token", required: true)
    tag("Transfer")
    description("Search transfer")
    response(200, "OK")

    parameters do
      id(:path, :string, "id transfer")
    end
  end

  def show(conn, %{"id" => id}) do
    transfer = TransferService.get_transfer!(id)
    json(conn, transfer)
  end

  swagger_path :create do
    post("/api/v1/transfer/")
    summary("Create transfer")
    produces("application/json")
    parameter("Authorization", :header, :string, "JWT access token", required: true)
    tag("Transfer")
    description("Create Transfer")
    response(200, "OK")

    parameters do
      transfer(:body, Schema.ref(:Transfer), "transfer atributes")
    end
  end

  def create(conn, %{
        "account_source" => account_source,
        "account_destiny" => account_destiny,
        "value" => value
      }) do
    with {:ok, %Account{} = account_source} <- AccountService.get_account!(account_source),
         {:ok, %Account{} = account_destiny} <- AccountService.get_account!(account_destiny) do
      case value <= account_source.value do
        true ->
          AccountService.decrease_value(account_source, value)
          AccountService.increase_value(account_destiny, value)

          TransferService.create_transfer(%{
            "account_source" => account_source.id,
            "account_destination" => account_destiny.id,
            "value" => value
          })

          # Send e-mail for user
          json(conn |> put_status(:created), :ok)
      end
    end
  end

  def swagger_definitions do
    %{
      Transfer:
        swagger_schema do
          title("Transfer")
          description("A transfer of the application")

          properties do
            account_source(:string, "Account source", required: true)
            account_destiny(:string, "Account destiny", required: true)
            value(:integer, "must have sufficient balance for transfer", required: true)
          end

          example(%{
            account_source: "id account source",
            account_destiny: "id account destiny",
            value: 983
          })
        end
    }
  end
end
