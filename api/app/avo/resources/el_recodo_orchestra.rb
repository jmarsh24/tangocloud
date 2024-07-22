class Avo::Resources::ElRecodoOrchestra < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, hide_on: [:index]
    field :name, as: :text
    field :image, as: :file, is_image: true
  end
end
