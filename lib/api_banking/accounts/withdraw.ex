defmodule ApiBanking.Accounts.Withdraw do
  alias ApiBanking.{Account, Accounts.Loader, Accounts.Mutator, Utils.Email}

  def withdraw(user_id, amount) when is_binary(user_id) and is_number(amount) do
    Loader.get_by_user(user_id)
    |> validate_amount(amount)
    |> withdraw_from_account()
    |> send_email()
  end

  def withdraw(_, _), do: {:error, "Invalid type of data"}

  def validate_amount(%Account{amount: amount} = account, value) do
    cond do
      amount >= value -> {:ok, account, value}
      true -> {:error, "Value is more than your amount"}
    end
  end

  def withdraw_from_account({:ok, %Account{amount: amount} = account, value}) do
    new_amount = amount - value

    case Mutator.update(account, %{amount: new_amount}) do
      {:ok, _} = account -> account
      {:error, _} = error -> error
    end
  end

  def withdraw_from_account({:error, _} = error), do: error

  defp send_email({:ok, %Account{}} = account) do
    Email.send()
    account
  end

  defp send_email({:error, _} = error), do: error
end
