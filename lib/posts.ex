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
    |> Enum.map(&post_to_changeset/1)
  end

  def reply_to_changeset(reply = %{}, parent_post_id) do
    # Always present values
    %{"created_at" => created_at,
      "location" => %{"name" => location},
      "color" => color,
      "user_handle" => user_handle,
      "vote_count" => vote_count,
      "message" => message,
      "post_id" => post_id} = reply

    # Optional values
    img_url = Map.get(reply, "image_url")
    parent_creator = Map.get(reply, "parent_creator")

    

    Jodelx.Reply.changeset(%Jodelx.Reply{},
                           %{created_at: created_at,
                             color: color,
                             location: location,
                             post_id: post_id,
                             vote_count: vote_count,
                             user_handle: user_handle,
                             message: message,
                             img_url: img_url,
                             parent_creator: to_boolean(parent_creator),
                             parent_post_id: parent_post_id})
  end

  def replies_to_changesets(nil, parent_post_id) do
    []
  end
  
  def replies_to_changesets(replies, parent_post_id) do
    Enum.map(replies, fn r -> reply_to_changeset(r, parent_post_id) end)
    #Enum.map(replies, &reply_to_changeset/1)
  end

  def post_to_changeset(post = %{}) do
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

    changeset_post = Jodelx.Post.changeset(%Jodelx.Post{},
                                           %{created_at: created_at,
                                             color: color,
                                             location: location,
                                             message: message,
                                             user_handle: user_handle,
                                             vote_count: vote_count,
                                             child_count: child_count,
                                             img_url: img_url,
                                             post_id: post_id})
    {changeset_post, replies_to_changesets(replies, post_id)}
  end
  
  def handle_call(:get_posts, _from, _state) do
    {:ok, reply} = Jodelx.Token.get_token |> Jodelx.Client.posts
    reply_body = reply.body |> :zlib.gunzip |> Poison.decode!
    %{"posts" => post_list} = reply_body

    {:reply, post_list, None}
  end

  def to_boolean(1), do: true
  def to_boolean(0), do: false
end
