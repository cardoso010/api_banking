defmodule ApiBankingWeb.AuthControllerTest do
  use ApiBankingWeb.ConnCase, async: true

  describe "sign_in" do
    test "sign_in user", %{conn: conn} do
      user = insert(:user)
      attrs = %{email: user.email, password: user.password}
      conn = post(conn, Routes.auth_path(conn, :sign_in), attrs)

      assert %{"token" => _} = json_response(conn, 200)
    end
  end
end
