defmodule ApiBank.AccountService do
  @moduledoc """
  The AccountService context.
  """

  import Ecto.Query, warn: false

  alias ApiBank.Repo
  alias ApiBank.Account

  @doc """
  Gets a account list.

  Return a list with all accounts
  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Get a account by `id`.

  Return account by id.
  """
  def get_account!(id) do
    resource = Repo.get!(Account, id)
    {:ok, resource}
  end

  @doc """
  Create a account, you need `user_id`

  Example %{"user_id" => user_id, "value" => 1000}
  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Update account decreasing a value
  """
  def decrease_value(%Account{} = account, value) do
    account
    |> Ecto.Changeset.change(value: account.value - value)
    |> Repo.update()
  end

  @doc """
  Update account increasing a value
  """
  def increase_value(%Account{} = account, value) do
    account
    |> Ecto.Changeset.change(value: account.value + value)
    |> Repo.update()
  end
end
