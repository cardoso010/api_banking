defmodule ApiBanking.Accounts.Withdraw do
  alias ApiBanking.{Account, Accounts.Loader, Accounts.Mutator, Utils.Email}
  alias ApiBanking.AccountLogs.Mutator, as: AccountLogsMutator

  @doc """
  Process to do a withdraw
  """
  def withdraw(user_id, amount) when is_binary(user_id) and is_number(amount) do
    Loader.get_by_user(user_id)
    |> validate_amount(amount)
    |> withdraw_from_account()
    |> save_log()
    |> send_email()
  end

  def withdraw(_, _), do: {:error, "Invalid type of data"}

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

  @doc """
  To do a withdraw from a account
  """
  def withdraw_from_account({:ok, %Account{amount: amount} = account, value}) do
    new_amount = amount - value

    case Mutator.update(account, %{amount: new_amount}) do
      {:ok, account} -> {:ok, account, value}
      {:error, _} = error -> error
    end
  end

  def withdraw_from_account({:error, _} = error), do: error

  defp send_email({:ok, %Account{}} = account) do
    Email.send()
    account
  end

  defp send_email({:error, _} = error), do: error

  defp save_log({:ok, account, amount}) do
    case AccountLogsMutator.create_withdraw(account.id, amount) do
      {:ok, _} -> {:ok, account}
      {:error, _} = error -> error
    end
  end

  defp save_log({:error, _} = error), do: error
end
