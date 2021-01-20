defmodule ApiBanking.AuthTest do
  use ApiBanking.DataCase, async: true

  alias ApiBanking.Auth

  describe "token_sign_in/2" do
    test "when pass user correct" do
      user = insert(:user)

      assert {:ok, _token, _claims} = Auth.token_sign_in(user.email, user.password)
    end

    test "when pass user incorrect" do
      user = insert(:user)

      assert {:error, :unauthorized} = Auth.token_sign_in(user.email, "wrong password")
    end

    test "when pass user nonexistent" do
      assert {:error, :unauthorized} = Auth.token_sign_in("ghost@user.com", "ghost password")
    end
  end
end
