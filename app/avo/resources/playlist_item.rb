class Avo::Resources::PlaylistItem < Avo::BaseResource
  self.includes = [:playlist, item: {image_attachment: :blob}]

  def fields
    field :id, hide_on: :index
    field :position, as: :number
    field :playlist, as: :belongs_to
    field :item, as: :belongs_to, polymorphic_as: :item, types: [::Recording, ::Tanda]
  end
end
