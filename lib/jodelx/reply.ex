defmodule Jodelx.Reply do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reply" do
    field :created_at, Ecto.DateTime
    field :color, :string
    field :location, :string
    field :post_id, :string
    field :vote_count, :integer
    field :user_handle, :string
    field :message, :string
    field :img_url, :string
  end

  def changeset(reply, params \\ %{}) do
    reply
    |> cast(params,
            [:created_at, :color, :location, :post_id, :vote_count,
             :user_handle, :message, :img_url])
    |> unique_constraint(:post_id)
  end
end
