defmodule ApiBanking.UserFactory do
  defmacro __using__(_opts) do
    quote do
      alias ApiBanking.User

      def user_factory do
        %User{
          id: id(),
          name: "Gabriel",
          email: "gabriel@test.com",
          password: "password123",
          password_confirmation: "password123",
          password_hash:
            "$argon2id$v=19$m=131072,t=8,p=4$OQ+fj2fNLEx5sWJZTBCZzQ$rCpYTRmkuioeSVYD5Cy188h6juFjIWraq1nr9ROqlpU"
        }
      end
    end
  end
end
