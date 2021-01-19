defmodule ApiBanking.UserFactory do
  defmacro __using__(_opts) do
    quote do
      alias ApiBanking.User

      def user_factory do
        %User{
          id: id(),
          name: "Gabriel",
          email: "gabriel@test.com",
          password: "password123"
        }
      end
    end
  end
end
