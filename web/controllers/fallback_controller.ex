defmodule ApiBank.FallbackController do
  use ApiBank.Web, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    errors =
      Enum.map(changeset.errors, fn {field, detail} ->
        %{
          detail: render_detail(detail)
        }
      end)

    conn
    |> put_status(:unprocessable_entity)
    |> json(%{"error" => errors})
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> render(ApiBank.Web.ErrorView, "auth_required.json")
  end

  def call(conn, {:error, :wrong_credentials}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(ApiBank.Web.ErrorView, "wrong_credentials.json")
  end

  def render_detail({message, values}) do
    Enum.reduce(values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end)
  end

  def render_detail(message) do
    message
  end
end
