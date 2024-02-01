class Avo::Resources::CoupleVideo < Avo::BaseResource
  self.includes = []
  self.visible_on_sidebar = false

  def fields
    field :id, as: :id
    field :couple_id, as: :text
    field :video_id, as: :text
    field :couple, as: :belongs_to
    field :video, as: :belongs_to
  end
end
