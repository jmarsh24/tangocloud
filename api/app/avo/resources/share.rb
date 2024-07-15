class Avo::Resources::Share < Avo::BaseResource
  self.includes = [:user, :shareable]

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :user, as: :belongs_to
    field :shareable,
      as: :belongs_to,
      polymorphic_as: :shareable,
      types: [::Recording, ::Tanda, ::Orchestra, ::Playlist],
      required: true
    field :created_at, as: :date_time
  end
end
