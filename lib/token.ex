defmodule Jodelx.Token do
  defstruct token: nil, expiration: 0

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %Jodelx.Token{}, name: __MODULE__)
  end

  def get_token do
    GenServer.call(__MODULE__, :get_token)
  end
  
  def handle_call(:get_token, _from, state) do
    case has_expired?(state) do
      false ->
        {:reply, state.token, state}
      true ->
        token_data = Jodelx.Client.register |> parse_token_reply

        {:reply, token_data.token, token_data}
    end
  end

  defp parse_token_reply({:ok, reply}) do
    json_struct = reply.body |> :zlib.gunzip |> Poison.decode!

    %{"access_token" => token,
      "expiration_date" => expiration} = json_struct

    %Jodelx.Token{token: token, expiration: expiration}
  end

  defp has_expired?(%Jodelx.Token{expiration: expiration}) do
    expiration < now
  end

  defp now do
    DateTime.utc_now |> DateTime.to_unix
  end
end
