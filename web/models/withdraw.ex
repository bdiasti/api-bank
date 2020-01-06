defmodule ApiBank.Withdraw do
  use ApiBank.Web, :model

  @moduledoc """
  Define Withdraw model.
  """

  @primary_key {:id, ApiBank.Ecto.Ksuid, autogenerate: true}
  schema "withdraw" do
    field(:account_id, :string)
    field(:value, :integer)
    timestamps()
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, [:account_id, :value])
    |> validate_number(:value, greater_than: 0)
  end
end
