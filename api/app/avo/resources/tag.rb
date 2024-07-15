class Avo::Resources::Tag < Avo::BaseResource
  self.title = :name
  self.includes = [:taggable, :user]
  self.search = {
    query: -> { query.search(params[:q]).results }
  }

  def fields
    field :id, as: :id
    field :tag, as: :belongs_to
    field :taggable,
      as: :belongs_to,
      polymorphic_as: :taggable,
      types: [::Recording, ::Tanda, ::Orchestra, ::Playlist, ::Composition, ::Person, ::User]
    field :user, as: :belongs_to

    field :created_at, as: :date_time
    field :updated_at, as: :date_time
  end
end
