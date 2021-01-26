defmodule ApiBanking.Accounts.Transfer do
  @moduledoc """
  Module to transfer money between account
  """
  alias ApiBanking.{
    Account,
    Accounts.AccountRules,
    Accounts.Loader,
    Accounts.Mutator
  }

  alias ApiBanking.AccountLogs.Mutator, as: AccountLogsMutator

  @doc """
  Process to do a transfer
  """
  def transfer(origin_id, destiny_id, amount)
      when is_binary(origin_id) and is_binary(destiny_id) and is_number(amount) do
    origin_account = Loader.get_by_user(origin_id)
    destiny_account = Loader.get_by_user(destiny_id)

    if exists_accounts?(origin_account, destiny_account, amount) do
      origin_account
      |> validate_amount(destiny_account, amount)
      |> withdraw_from_account()
      |> transfer_to_account()
      |> save_log()
    else
      {:error, "User non-existent"}
    end
  end

  def transfer(_, _, _), do: {:error, "Invalid type of data"}

  defp exists_accounts?(%Account{}, %Account{}, _amount),
    do: true

  defp exists_accounts?(_origin_account, _destiny_account, _amount),
    do: false

  defp validate_amount(%Account{} = origin, %Account{} = destiny, amount) do
    case AccountRules.validate_amount(origin, amount) do
      {:ok, _, _} -> {:ok, origin, destiny, amount}
      _ = error -> error
    end
  end

  @doc """
  To do a withdraw from a account
  """
  defp withdraw_from_account(
         {:ok, %Account{amount: amount} = origin_account, %Account{} = destiny_account, value}
       ) do
    new_amount = amount - value

    case Mutator.update(origin_account, %{amount: new_amount}) do
      {:ok, origin_account} -> {:ok, origin_account, destiny_account, value}
      {:error, _} = error -> error
    end
  end

  defp withdraw_from_account({:error, _} = error), do: error

  @doc """
  To do a transfer to a destiny account
  """
  defp transfer_to_account(
         {:ok, %Account{} = origin_account, %Account{amount: amount} = destiny_account, value}
       ) do
    new_amount = amount + value

    case Mutator.update(destiny_account, %{amount: new_amount}) do
      {:ok, destiny_account} -> {:ok, origin_account, destiny_account, value}
      {:error, _} = error -> error
    end
  end

  defp transfer_to_account({:error, _} = error), do: error

  defp save_log({:ok, %Account{id: origin_id}, %Account{id: destiny_id}, amount}) do
    case AccountLogsMutator.create_transfer(origin_id, destiny_id, amount) do
      {:ok, _} -> :ok
      {:error, _} = error -> error
    end
  end

  defp save_log({:error, _} = error), do: error
end
