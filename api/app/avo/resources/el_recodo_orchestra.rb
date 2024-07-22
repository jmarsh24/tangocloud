class Avo::Resources::ElRecodoOrchestra < Avo::BaseResource
  self.includes = [:el_recodo_songs, :el_recodo_person_roles, [image_attachment: :blob]]
  self.search = {
    query: -> {
             query.search(params[:q],
               fields: [:name], match: :word_start,
               misspellings: {below: 5})
           }
  }

  def fields
    field :id, as: :id, hide_on: [:index]
    field :name, as: :text
    field :image, as: :file, is_image: true
    field :el_recodo_songs, as: :has_many
  end
end
