defmodule Jodelx.Repo.Migrations.CreateReplies do
  use Ecto.Migration

  def change do
    create table(:reply) do
      add :created_at, :datetime
      add :color, :string
      add :location, :string
      add :post_id, :string
      add :vote_count, :integer
      add :user_handle, :string
      add :message, :string
      add :img_url, :string
      add :parent_creator, :boolean
      add :parent_post_id, :string
    end

    create unique_index(:reply, [:post_id])
  end
end
