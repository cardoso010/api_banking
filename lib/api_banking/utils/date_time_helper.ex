defmodule ApiBanking.Utils.DateTimeHelper do
  def get_naive_date_time(year \\ 0, month \\ 0, day \\ 0) do
    %NaiveDateTime{year: year, month: month, day: day, hour: 0, minute: 0, second: 0}
  end
end
