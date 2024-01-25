# frozen_string_literal: true

class Avo::Resources::AudioTransfer < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :method, as: :text
    field :external_id, as: :text
    field :recording_date, as: :date
    field :transfer_agent_id, as: :text
    field :audio_id, as: :text
    field :audio, as: :belongs_to
    field :transfer_agent, as: :belongs_to
  end
end
