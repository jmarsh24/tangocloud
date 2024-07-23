class Avo::Resources::PlaylistItem < Avo::BaseResource
  self.includes = [:playlist]

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :playlist, as: :belongs_to
    field :item,
      as: :belongs_to,
      polymorphic_as: :reviewable,
      types: [::Recording, ::Tanda]
  end
end
