defmodule ApiBank.UserController do
  use ApiBank.Web, :controller
  use PhoenixSwagger

  alias ApiBank.User
  alias ApiBank.Guardian
  alias ApiBank.UserService

  action_fallback(ApiBank.FallbackController)

  swagger_path :index do
    get("/api/v1/users")
    summary("Query for users")
    produces("application/json")
    parameter("Authorization", :header, :string, "JWT access token", required: true)
    tag("Users")
    description("List all users")
    response(200, "OK")
  end

  def index(conn, _params) do
    users = UserService.list_users()
    json(conn, users)
  end

  swagger_path :show do
    get("/api/v1/users/{id}")
    summary("Query user by id")
    produces("application/json")
    parameter("Authorization", :header, :string, "JWT access token", required: true)
    tag("Users")
    description("Search user")
    response(200, "OK")

    parameters do
      id(:path, :string, "id user")
    end
  end

  def show(conn, %{"id" => id}) do
    user = UserService.get_user!(id)
    json(conn, user)
  end

  swagger_path :create do
    post("/api/v1/sign_up/")
    summary("Create user")
    produces("application/json")
    tag("Users")
    description("Create user")
    response(200, "OK")

    parameters do
      user(:body, Schema.ref(:User), "user attributes")
    end
  end

  def create(conn, params) do
    with {:ok, %User{} = user} <- UserService.create_user(params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      json(conn, %{"jwt" => token})
    end
  end

  swagger_path :sign_in do
    post("/api/v1/sign_in/")
    summary("Login user")
    produces("application/json")
    tag("Users")
    description("Login user")
    response(200, "OK")

    parameters do
      user(:body, Schema.ref(:UserLogin), "user attributes")
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case UserService.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        json(conn, %{"jwt" => token})

      _ ->
        {:error, :unauthorized}
    end
  end

  def swagger_definitions do
    %{
      User:
        swagger_schema do
          title("User")
          description("A user of the application")

          properties do
            email(:string, "Users name", required: true)
            password(:string, "Unique identifier", required: true)
            password_confirmation(:string, "Home address")
          end

          example(%{
            email: "bdias.ti@gmail.com",
            password: "12345678",
            password_confirmation: "12345678"
          })
        end,
      UserLogin:
        swagger_schema do
          title("Users Login")
          description("A collection of Users")

          properties do
            email(:string, "Users name", required: true)
            password(:string, "Unique identifier", required: true)
          end

          example(%{
            email: "bdias.ti@gmail.com",
            password: "12345678"
          })
        end
    }
  end
end
