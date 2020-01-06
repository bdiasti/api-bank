defmodule ApiBank.Account do
  use ApiBank.Web, :model

  @moduledoc """
  Define Account model.
  """

  @primary_key {:id, ApiBank.Ecto.Ksuid, autogenerate: true}
  schema "account" do
    field(:user_id, :string)
    field(:value, :integer, default: 1000)
    timestamps()
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, [:user_id, :value])
    |> validate_number(:value, greater_than: 0)
  end
end
