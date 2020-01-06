defmodule ApiBank.WithdrawService do
  @moduledoc """
  The WithdrawService context.
  """
  alias ApiBank.Repo
  alias ApiBank.Withdraw

  @doc """
  Gets withdraw by `id`
  """
  def get_withdraw!(id), do: Repo.get!(Withdraw, id)

  @doc """
  Gets a withdraw
  """
  def create_withdraw(attrs \\ %{}) do
    %Withdraw{}
    |> Withdraw.changeset(attrs)
    |> Repo.insert()
  end
end
