defmodule ApiBanking.Accounts.Withdraw do
  @moduledoc """
  Module to do withdraw from user's account
  """
  alias ApiBanking.{
    Account,
    Accounts.AccountRules,
    Accounts.Loader,
    Accounts.Mutator,
    Utils.Email
  }

  alias ApiBanking.AccountLogs.Mutator, as: AccountLogsMutator

  @doc """
  Process to do a withdraw
  """
  def withdraw(origin_id, amount) when is_binary(origin_id) and is_number(amount) do
    Loader.get_by_user(origin_id)
    |> AccountRules.validate_amount(amount)
    |> withdraw_from_account()
    |> save_log()
    |> send_email()
  end

  def withdraw(_, _), do: {:error, "Invalid type of data"}

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
