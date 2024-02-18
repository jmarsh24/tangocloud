class Avo::Resources::TransferAgent < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :description, as: :textarea
    field :url, as: :text
    field :image, as: :file
    field :logo, as: :file
    field :audio_transfers, as: :has_many
    field :audio_variants, as: :has_many, through: :audio_transfers
    field :recordings, as: :has_many, through: :audio_transfers
  end
end
