# frozen_string_literal: true

class Avo::Resources::DancerVideo < Avo::BaseResource
  self.includes = []
  self.visible_on_sidebar = false

  def fields
    field :id, as: :id
    field :dancer_id, as: :text
    field :video_id, as: :text
    field :dancer, as: :belongs_to
    field :video, as: :belongs_to
  end
end
