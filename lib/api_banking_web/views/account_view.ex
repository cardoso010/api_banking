defmodule ApiBankingWeb.AccountView do
  use ApiBankingWeb, :view

  def render("account.json", %{account: account}) do
    %{user_id: account.user_id, amount: account.amount}
  end
end
