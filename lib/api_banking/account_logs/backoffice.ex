defmodule ApiBanking.AccountLogs.Backoffice do
  @moduledoc """
  Module to get a report of transactions
  """
  alias ApiBanking.AccountLogs.Loader
  alias ApiBanking.Utils.DateTimeHelper

  @doc """
  Generate report by it's filter
  if all values ​​have been filled in, a report for the day will be generated,
  if it is year and month, a report for the month will be generated and
  if only the year is filled in, the report for the year will be generated.
  if none is filled, the general report will be generated.
  """
  def report(nil, nil, nil) do
    total = Loader.get_total_sum()

    {:ok, %{"total" => total}}
  end

  def report(year, nil, nil) when is_number(year) do
    date = DateTimeHelper.get_naive_date_time(year, 0, 0)
    generate_report("year", date)
  end

  def report(year, month, nil) when is_number(year) and is_number(month) do
    date = DateTimeHelper.get_naive_date_time(year, month, 0)
    generate_report("month", date)
  end

  def report(year, month, day) when is_number(year) and is_number(month) and is_number(day) do
    date = DateTimeHelper.get_naive_date_time(year, month, day)
    generate_report("day", date)
  end

  def report(_, _, _), do: {:error, "Invalid type of data"}

  defp generate_report("day", date) do
    total = Loader.get_total_by_day(date)

    {:ok, %{"total per day" => total}}
  end

  defp generate_report("month", date) do
    start_date = Timex.beginning_of_month(date)
    end_date = Timex.end_of_month(date)

    total = Loader.get_total_between_dates(start_date, end_date)

    {:ok, %{"total per month" => total}}
  end

  defp generate_report("year", date) do
    start_date = Timex.beginning_of_year(date)
    end_date = Timex.end_of_year(date)

    total = Loader.get_total_between_dates(start_date, end_date)

    {:ok, %{"total per year" => total}}
  end
end
