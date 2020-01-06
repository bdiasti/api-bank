defmodule ApiBank.TransferTest do
  use ApiBank.ConnCase

  alias ApiBank.AccountService
  alias ApiBank.TransferService
  alias ApiBank.Account
  alias ApiBank.User
  alias ApiBank.UserService

  describe "Transfer" do
    test "Create a transfer with success" do
      {:ok, %User{} = user_bernardo} =
        UserService.create_user(%{
          "email" => "bdias.ti@gmail.com",
          "password_confirmation" => "12345678",
          "password" => "12345678"
        })

      {:ok, %Account{} = account_bernardo} =
        AccountService.create_account(%{
          "user_id" => user_bernardo.id
        })

      {:ok, %User{} = user_joao} =
        UserService.create_user(%{
          "email" => "joao@gmail.com",
          "password_confirmation" => "12345678",
          "password" => "12345678"
        })

      {:ok, %Account{} = account_joao} =
        AccountService.create_account(%{
          "user_id" => user_joao.id
        })

      TransferService.create_transfer(%{
        "account_source" => account_bernardo.id,
        "account_destination" => account_joao.id,
        "value" => 500
      })

      AccountService.decrease_value(account_bernardo, 500)
      AccountService.increase_value(account_joao, 500)

      {:ok, %Account{} = account_bernardo_up} = AccountService.get_account!(account_bernardo.id)
      {:ok, %Account{} = account_joao_up} = AccountService.get_account!(account_joao.id)

      assert 500 == account_bernardo_up.value
      assert 1500 == account_joao_up.value
    end
  end
end
