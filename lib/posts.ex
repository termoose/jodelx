defmodule Jodelx.Posts do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, None, name: __MODULE__)
  end

  def handle_call(:get_posts, _from, _state) do
    {:ok, reply} = Jodelx.Token.get_token |> Jodelx.Client.posts
    reply_body = reply.body |> Poison.decode!
    %{"posts" => post_list} = reply_body

    {:reply, post_list, None}
  end
end
