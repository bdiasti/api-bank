defmodule ApiBank.ReportController do
  use ApiBank.Web, :controller
  use PhoenixSwagger

  alias ApiBank.ReportService

  swagger_path :transaction_month do
    get("/api/v1/report/month/{month}/{year}")
    summary("Report transaction by month")
    produces("application/json")
    parameter("Authorization", :header, :string, "JWT access token", required: true)
    tag("Reports")
    description("Report transaction by month")
    response(200, "OK")

    parameters do
      month(:path, :string, "month")
      year(:path, :string, "year")
    end
  end

  def transaction_month(conn, %{"month" => month, "year" => year}) do
    json(conn, ReportService.transaction_month(month, year))
  end

  swagger_path :transaction_day do
    get("/api/v1/report/day/{day}/{month}/{year}")
    summary("Report transaction by day")
    produces("application/json")
    parameter("Authorization", :header, :string, "JWT access token", required: true)
    tag("Reports")
    description("Report transaction by month")
    response(200, "OK")

    parameters do
      day(:path, :string, "day")
      month(:path, :string, "month")
      year(:path, :string, "year")
    end
  end

  def transaction_day(conn, %{"day" => day, "month" => month, "year" => year}) do
    json(conn, ReportService.transaction_day(day, month, year))
  end

  swagger_path :index do
    get("/api/v1/total")
    summary("Total transactions")
    produces("application/json")
    parameter("Authorization", :header, :string, "JWT access token", required: true)
    tag("Reports")
    description("Report with all transactions transfer and withdraw")
    response(200, "OK")
  end

  def transaction_total(conn, _) do
    json(conn, ReportService.total())
  end
end
