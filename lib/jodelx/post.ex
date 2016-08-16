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
  end

  def changeset(post, params \\ %{}) do
    post
    |> cast(params, [:created_at])
    |> unique_constraint(:created_at)
  end
end
