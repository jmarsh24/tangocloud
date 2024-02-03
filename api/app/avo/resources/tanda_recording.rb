class Avo::Resources::TandaRecodings < Avo::BaseResource
  self.includes = []
  self.visible_on_sidebar = false

  def fields
    field :id, as: :id
    field :position, as: :number
    field :tanda_id, as: :text
    field :audio_transfer_id, as: :text
    field :tanda, as: :belongs_to
    field :audio_transfer, as: :belongs_to
  end
end
