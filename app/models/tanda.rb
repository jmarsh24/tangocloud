class Tanda < ApplicationRecord
  include Playlistable

  belongs_to :user, optional: true
  has_many :tanda_recordings, dependent: :destroy
  has_many :tanda_items, through: :tanda_recordings, source: :item, source_type: "TandaItem", dependent: :destroy
  has_many :recordings, through: :tanda_recordings, inverse_of: :tandas

  def attach_default_image
    unique_album_arts = recordings.includes(digital_remasters: { album: { album_art_attachment: :blob } })
                                  .filter_map { _1.digital_remasters.first&.album&.album_art }
                                  .uniq

    return if unique_album_arts.empty?

    if unique_album_arts.size < 4
      image.attach(unique_album_arts.first.blob) if unique_album_arts.first&.blob
    else
      create_and_attach_composite_image(unique_album_arts.take(4))
    end
  end
end

# == Schema Information
#
# Table name: tandas
#
#  id              :uuid             not null, primary key
#  title           :string           not null
#  subtitle        :string
#  description     :text
#  slug            :string
#  public          :boolean          default(TRUE), not null
#  system          :boolean          default(FALSE), not null
#  user_id         :uuid
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  playlists_count :integer          default(0), not null
#
