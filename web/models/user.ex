defmodule ApiBank.User do
  use ApiBank.Web, :model

  @moduledoc """
  Define User model.
  """

  alias ApiBank.User
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  @primary_key {:id, ApiBank.Ecto.Ksuid, autogenerate: true}
  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:password_hash, :string)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, hashpwsalt(pass))

      _ ->
        changeset
    end
  end
end
