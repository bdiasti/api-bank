defmodule ApiBank.AccountsTest do
  use ApiBank.ConnCase

  alias ApiBank.AccountService
  alias ApiBank.Account
  alias ApiBank.User
  alias ApiBank.UserService

  describe "Account" do
    test "get_account!/1 get account" do
      {:ok, %User{} = user} =
        UserService.create_user(%{
          "email" => "bdias.ti@gmail.com",
          "password_confirmation" => "12345678",
          "password" => "12345678"
        })

      {:ok, %Account{} = account} =
        AccountService.create_account(%{
          "user_id" => user.id
        })

      {:ok, %Account{} = account_get} = AccountService.get_account!(account.id)
      assert account_get.id == account.id
    end

    test "Account must start with 1000 ammount" do
      {:ok, %User{} = user} =
        UserService.create_user(%{
          "email" => "bdias1990@gmail.com",
          "password_confirmation" => "12345678",
          "password" => "12345678"
        })

      {:ok, %Account{} = account} =
        AccountService.create_account(%{
          "user_id" => user.id
        })

      assert 1000 == account.value
    end
  end
end
