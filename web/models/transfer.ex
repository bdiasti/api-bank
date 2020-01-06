defmodule ApiBank.Transfer do
  use ApiBank.Web, :model

  @moduledoc """
  Define Transfer model.
  """

  @primary_key {:id, ApiBank.Ecto.Ksuid, autogenerate: true}
  schema "transfer" do
    field(:account_source, :string)
    field(:account_destination, :string)
    field(:value, :integer)
    timestamps()
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, [:account_source, :value])
    |> validate_number(:value, greater_than: 0)
  end
end
