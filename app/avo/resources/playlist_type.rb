class Avo::Resources::PlaylistType < Avo::BaseResource
  self.includes = [:playlists]

  def fields
    field :id, as: :id
    field :name, as: :text
    field :playlists, as: :has_many
  end
end
