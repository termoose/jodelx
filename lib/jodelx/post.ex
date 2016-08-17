defmodule Jodelx.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "post" do
    field :created_at, :string
    field :color, :string
    field :location, :string
    field :message, :string
    field :user_handle, :string
    field :vote_count, :integer
    field :child_count, :integer
    field :img_url, :string
    field :post_id, :string
  end

  def changeset(post, params \\ %{}) do
    post
    |> cast(params,
            [:created_at, :color, :location, :message, :user_handle,
             :vote_count, :child_count, :img_url, :post_id])
    |> unique_constraint(:post_id)
  end
end
