# frozen_string_literal: true

class Avo::Resources::Audio < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :duration, as: :number
    field :format, as: :text
    field :bit_rate, as: :number
    field :sample_rate, as: :number
    field :channels, as: :number
    field :bit_depth, as: :number
    field :audio_transfers, as: :has_many
    field :transfer_agents, as: :has_many, through: :audio_transfers
  end
end
