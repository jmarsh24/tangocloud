class Avo::Resources::PlaylistItem < Avo::BaseResource
  self.includes = [:playlistable, :item]

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :playlistable, as: :belongs_to, polymorphic_as: :playlistable, types: [::Playlist, ::Tanda]
    field :item, as: :belongs_to, polymorphic_as: :item, types: [::Recording, ::Tanda]
    field :position, as: :number
    field :created_at, as: :date, readonly: true
    field :updated_at, as: :date, readonly: true
  end
end
