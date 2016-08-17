defmodule Jodelx.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:post) do
      add :created_at, :datetime
      add :color, :string
      add :location, :string
      add :message, :string
      add :user_handle, :string
      add :vote_count, :integer
      add :child_count, :integer
      add :img_url, :string
      add :post_id, :string
    end

    # Make sure the created_at timestamp is unique to
    # avoid collisions in the database
    create unique_index(:post, [:post_id])
  end
end
