defmodule Jodelx.Fetcher do
  use GenServer

  def start_link(delay) do
    GenServer.start_link(__MODULE__, delay, name: __MODULE__)
  end

  def init(delay) do
    schedule_work(delay)
    {:ok, delay}
  end

  def push_to_db(entry = {post, replies}) do
    # Insert the post
    Jodelx.Repo.insert(post)

    # Insert the replies
    replies
    |> Enum.map(&Jodelx.Repo.insert/1)
  end

  def handle_info(:work, delay) do
    Jodelx.Posts.get_changeset_posts
    |> Enum.map(&push_to_db/1)

    
    schedule_work(delay)
    {:noreply, delay}
  end

  defp schedule_work(delay) do
    # Convert delay to miliseconds
    Process.send_after(self(), :work, delay * 1000)
  end
end
