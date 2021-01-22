defmodule ApiBanking.Accounts.AccountRules do
  @moduledoc """
  Common rules of Account
  """
  alias ApiBanking.Account

  @doc """
  Validate if value passed is higher than account's amount
  """
  def validate_amount(%Account{amount: amount} = account, value) do
    if amount >= value do
      {:ok, account, value}
    else
      {:error, "Value is more than your amount"}
    end
  end

  def validate_amount(nil, _value), do: {:error, "User non-existent"}
end
