defmodule Jodelx.Fetcher do
  use GenServer

  def start_link(delay) do
    GenServer.start_link(__MODULE__, delay, name: __MODULE__)
  end

  def init(delay) do
    schedule_work(delay)
    {:ok, delay}
  end

  def handle_info(:work, delay) do
    Jodelx.Posts.get_changeset_posts
    #|> Enum.take(10)
    |> Enum.map(&Jodelx.Repo.insert/1)
    #|> Enum.map(fn change -> #IO.inspect change
    #                         case Jodelx.Repo.insert(change) do
    #                           {:ok, _} -> IO.puts "#{inspect change} added!"
    #                           {:error, reason} -> IO.inspect reason
    #                         end end)

    schedule_work(delay)
    {:noreply, delay}
  end

  defp schedule_work(delay) do
    # Convert delay to miliseconds
    Process.send_after(self(), :work, delay * 1000)
  end
end
