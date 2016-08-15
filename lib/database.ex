use Amnesia

defdatabase Jodelx.Database do
  deftable Post, [:created_at, :vote_count, :location_name,
                  :child_count, :color, :user_handle, :image_url, :message] do
  end
end
