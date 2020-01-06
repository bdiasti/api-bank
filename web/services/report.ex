defmodule ApiBank.ReportService do
  @moduledoc """
  The ReportService context.
  """

  import Ecto.Query, warn: false

  alias ApiBank.Repo
  alias ApiBank.Transfer
  alias ApiBank.Withdraw

  @doc """
  Gets total transactions Transfer and Withdraw by month passing `month` and `year`
  """
  def transaction_month(month, year) do
    {month_p, ""} = Integer.parse(month)
    {year_p, ""} = Integer.parse(year)

    query_transfer =
      from(p in Transfer,
        where:
          fragment("date_part('month', ?)", p.inserted_at) == ^month_p and
            fragment("date_part('year', ?)", p.inserted_at) == ^year_p
      )

    query_withdraw =
      from(p in Withdraw,
        where:
          fragment("date_part('month', ?)", p.inserted_at) == ^month_p and
            fragment("date_part('year', ?)", p.inserted_at) == ^year_p
      )

    Repo.aggregate(query_withdraw, :sum, :value) + Repo.aggregate(query_transfer, :sum, :value)
  end

  @doc """
  Gets total transaction Transfer and Withdraw by day passing `day` , `month` and `year`
  """
  def transaction_day(day, month, year) do
    {day_p, ""} = Integer.parse(day)
    {month_p, ""} = Integer.parse(month)
    {year_p, ""} = Integer.parse(year)

    query_transfer =
      from(p in Transfer,
        where:
          fragment("date_part('day', ?)", p.inserted_at) == ^day_p and
            fragment("date_part('month', ?)", p.inserted_at) == ^month_p and
            fragment("date_part('year', ?)", p.inserted_at) == ^year_p
      )

    query_withdraw =
      from(p in Withdraw,
        where:
          fragment("date_part('day', ?)", p.inserted_at) == ^day_p and
            fragment("date_part('month', ?)", p.inserted_at) == ^month_p and
            fragment("date_part('year', ?)", p.inserted_at) == ^year_p
      )

    Repo.aggregate(query_withdraw, :sum, :value) + Repo.aggregate(query_transfer, :sum, :value)
  end

  @doc """
  Gets total transaction Transfer and Withdraw
  """
  def total() do
    Repo.aggregate(Transfer, :sum, :value) + Repo.aggregate(Withdraw, :sum, :value)
  end
end
