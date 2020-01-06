defmodule ApiBank.TransferService do
  @moduledoc """
  The TransferService context.
  """

  alias ApiBank.Repo
  alias ApiBank.Transfer

  import Ecto.Query, warn: false

  @doc """
  Gets transfer by `id`
  """
  def get_transfer!(id) do
    resource = Repo.get!(Transfer, id)
    {:ok, resource}
  end

  @doc """
  Gets a transfer
  """
  def create_transfer(attrs \\ %{}) do
    %Transfer{}
    |> Transfer.changeset(attrs)
    |> Repo.insert()
  end
end
