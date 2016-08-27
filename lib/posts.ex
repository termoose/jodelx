defmodule Jodelx.Posts do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, None, name: __MODULE__)
  end

  def get_posts do
    GenServer.call(__MODULE__, :get_posts)
  end

  def get_changeset_posts do
    get_posts
    |> Enum.reverse
    |> Enum.map(&to_changeset/1)
  end

  def to_changeset(post = %{}) do
    # Values that are always present
    %{"created_at" => created_at,
      "location" => %{"name" => location},
      "user_handle" => user_handle,
      "vote_count" => vote_count,
      "post_id" => post_id} = post

    # Optional values
    color = Map.get(post, "color")
    message = Map.get(post, "message")
    child_count = Map.get(post, "child_count")
    img_url = Map.get(post, "image_url")
    replies = Map.get(post, "children")

    Jodelx.Post.changeset(%Jodelx.Post{}, %{created_at: created_at,
                                            color: color,
                                            location: location,
                                            message: message,
                                            user_handle: user_handle,
                                            vote_count: vote_count,
                                            child_count: child_count,
                                            img_url: img_url,
                                            post_id: post_id})
  end
  
  def handle_call(:get_posts, _from, _state) do
    {:ok, reply} = Jodelx.Token.get_token |> Jodelx.Client.posts
    reply_body = reply.body |> :zlib.gunzip |> Poison.decode!
    %{"posts" => post_list} = reply_body

    {:reply, post_list, None}
  end
end
