class Avo::Resources::Album < Avo::BaseResource
  self.includes = [:digital_remasters]
  self.attachments = [:album_art]
  self.search = {
    query: -> { query.search(params[:q]).results }
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :album_art, as: :file, is_image: true
    field :title, as: :text
    field :description, as: :textarea
    field :release_date, as: :date
    field :external_id, as: :text, only_on: :show, readonly: true
    field :digital_remasters, as: :has_many
  end
end
