defmodule ApiBanking.AccountFactory do
  defmacro __using__(_opts) do
    quote do
      alias ApiBanking.Account

      def account_factory do
        %Account{
          id: id(),
          user_id: "user_id",
          amount: 1000
        }
      end
    end
  end
end
