defmodule ApiBanking.Utils.DateTimeHelperTest do
  use ApiBanking.DataCase, async: true

  alias ApiBanking.Utils.DateTimeHelper

  describe "get_naive_date_time/3" do
    test "return NaiveDateTime" do
      naive_date_time = DateTimeHelper.get_naive_date_time(2020, 2, 2)
      assert %NaiveDateTime{} = naive_date_time
      assert %NaiveDateTime{year: 2020, month: 2, day: 2} = naive_date_time
    end
  end
end
