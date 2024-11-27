class Avo::Resources::Album < Avo::BaseResource
  self.includes = [:digital_remasters]
  self.attachments = [:album_art]
  self.search = {
    query: -> { query.search(params[:q]) }
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :album_art, as: :file, is_image: true
    field :title, as: :text
    field :description, as: :textarea
    field :release_date, as: :date, only_on: :show
    field :digital_remasters, as: :has_many
  end
end
