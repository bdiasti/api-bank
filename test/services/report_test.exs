defmodule ApiBank.ReportTest do
  use ApiBank.ConnCase

  alias ApiBank.AccountService
  alias ApiBank.TransferService
  alias ApiBank.WithdrawService
  alias ApiBank.ReportService
  alias ApiBank.Account
  alias ApiBank.User
  alias ApiBank.UserService

  describe "Report" do
    test "transaction_month/2 transactions by month" do
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
        "value" => 200
      })

      WithdrawService.create_withdraw(%{"account_id" => account_bernardo.id, "value" => 200})

      value = ReportService.transaction_month("01", "2020")

      assert 400 == value
    end
  end
end
