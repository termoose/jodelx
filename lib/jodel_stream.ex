defmodule Jodelx.JodelStream do
  import Ecto.Query
  use GenEvent

  def start_link do
    GenEvent.start_link(__MODULE__, None, name: __MODULE__)
  end

  def handle_info(:work, time) do
    
    {:noreply, time}
  end

  defp schedule_print do
    Process.send_after(self(), :work, 1000)
  end


  # DEPRECATED below
  def get_stream do
    Stream.resource(&Jodelx.JodelStream.start_fun/0,
                    &Jodelx.JodelStream.next_fun/1,
      fn acc -> acc end)
  end

  # Start time
  def start_fun do
    #DateTime.from_unix!(0)
    #|> Ecto.DateTime.cast!
    query = from p in Jodelx.Post, order_by: [p.id], limit: 1
    Jodelx.Repo.one(query)
    |> Map.get(:created_at)
  end

  def gen_query(time) do
    from p in Jodelx.Post, select: p,
    where: p.created_at > ^time,
    order_by: p.id
  end

  # Check db every second for posts newer than time
  def next_fun(time) do
    query = gen_query(time)
    posts = Jodelx.Repo.all(query)

    :timer.sleep(1000)

    case Enum.take(posts, -1) do
      [] -> {posts, time}
      [elem] -> {posts, elem.created_at}
    end
  end
end
