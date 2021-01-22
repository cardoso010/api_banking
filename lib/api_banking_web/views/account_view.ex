defmodule ApiBankingWeb.AccountView do
  use ApiBankingWeb, :view

  def render("withdraw.json", %{account: account}) do
    %{user_id: account.user_id, amount: account.amount}
  end

  def render("transfer.json", %{
        transfer: %{sender_id: sender_id, receiver_id: receiver_id, amount: amount}
      }) do
    %{sender_id: sender_id, receiver_id: receiver_id, amount: amount}
  end
end
