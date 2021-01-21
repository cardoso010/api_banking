defmodule ApiBanking.AccountLogFactory do
  defmacro __using__(_opts) do
    quote do
      alias ApiBanking.AccountLog

      def account_log_factory do
        %AccountLog{
          id: id(),
          movement_type: :withdraw,
          amount: 500,
          origin_id: nil,
          destiny_id: nil
        }
      end
    end
  end
end
