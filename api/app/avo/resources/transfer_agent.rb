class Avo::Resources::TransferAgent < Avo::BaseResource
  self.includes = [:audio_transfers, :audio_variants, :recordings]
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :name, as: :text
    field :description, as: :textarea, only_on: :show
    field :url, as: :text
    field :image, as: :file, is_image: true, accept: "image/*", display_filename: false, required: true
    field :logo, as: :file, is_image: true, accept: "image/*", display_filename: false, required: true
    field :audio_transfers, as: :has_many
    field :audio_variants, as: :has_many, through: :audio_transfers
    field :recordings, as: :has_many, through: :audio_transfers
  end
end
