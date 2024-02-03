class Avo::Resources::PlaylistAudioTransfer < Avo::BaseResource
  self.includes = []
  self.visible_on_sidebar = false

  def fields
    field :id, as: :id
    field :playlist_id, as: :text
    field :audio_transfer_id, as: :text
    field :position, as: :number
    field :playlist, as: :belongs_to
    field :audio_transfer, as: :belongs_to
  end
end
