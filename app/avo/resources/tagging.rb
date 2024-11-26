class Avo::Resources::Tagging < Avo::BaseResource
  self.title = :name
  self.includes = [:taggable, :user, :tag]

  def fields
    field :id, as: :id, hide_on: [:index]
    field :name, as: :text
    field :user, as: :belongs_to
    field :taggable, as: :belongs_to, polymorphic_as: :taggable, types: [::Tanda]
    field :tag, as: :belongs_to
    field :created_at, as: :date, readonly: true
  end
end
