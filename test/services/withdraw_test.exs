defmodule ApiBank.WithdrawTest do
  use ApiBank.ConnCase

  alias ApiBank.AccountService
  alias ApiBank.WithdrawService
  alias ApiBank.Account
  alias ApiBank.User
  alias ApiBank.UserService

  describe "Withdraw" do
    test "Create a Withdraw with success" do
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

      WithdrawService.create_withdraw(%{
        "account_source" => account_bernardo.id,
        "value" => 500
      })

      AccountService.decrease_value(account_bernardo, 500)

      {:ok, %Account{} = account_bernardo_up} = AccountService.get_account!(account_bernardo.id)

      assert 500 == account_bernardo_up.value
    end
  end
end
