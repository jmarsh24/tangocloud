class Avo::Resources::AudioVariant < Avo::BaseResource
  self.includes = [digital_remaster: [album: [album_art_attachment: :blob], recording: [:composition]]]
  self.search = {
    query: -> { query.search(params[:q]) }
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :image, as: :file, is_image: true, accept: "image/*" do
      record.digital_remaster.album.album_art
    end
    field :audio_file, as: :file, readonly: true, display_filename: false, hide_on: :index
    field :format, as: :text, readonly: true, only_on: :show
    field :bit_rate, as: :number, readonly: true, only_on: :show
    field :digital_remaster, as: :belongs_to, readonly: true
  end
end
