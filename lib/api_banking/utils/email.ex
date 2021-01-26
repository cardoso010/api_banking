defmodule ApiBanking.Utils.Email do
  @moduledoc """
  Module to "send" email
  """
  use GenServer
  require Logger

  def init(state), do: {:ok, state}

  def handle_cast(:send, state) do
    Logger.info("Sending email...")
    {:noreply, state}
  end

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def send, do: GenServer.cast(__MODULE__, :send)
end
