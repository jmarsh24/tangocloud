class Playlist < ApplicationRecord
  include Playlistable

  has_many :playlist_items, dependent: :destroy
  has_many :recordings, through: :playlist_items, source: :item, source_type: "Recording"
  has_many :tandas, through: :playlist_items, source: :item, source_type: "Tanda"
  has_many :library_items, as: :item, dependent: :destroy

  belongs_to :playlist_type, optional: true

  scope :exclude_liked, -> {
    left_joins(:playlist_type)
      .where(playlist_types: {name: nil})
      .or(left_joins(:playlist_type).where.not(playlist_types: {name: "Liked"}))
  }

  def attach_default_image
    unique_album_arts = recordings.includes(digital_remasters: {album: {album_art_attachment: :blob}})
      .filter_map { _1.digital_remasters.first&.album&.album_art }
      .uniq

    if unique_album_arts.empty?
      unique_album_arts = tandas.includes(recordings: {digital_remasters: {album: {album_art_attachment: :blob}}})
        .flat_map { |tanda| tanda.recordings }
        .filter_map { _1.digital_remasters.first&.album&.album_art }
        .uniq
    end

    return if unique_album_arts.empty?

    if unique_album_arts.size < 4
      image.attach(unique_album_arts.first.blob) if unique_album_arts.first&.blob
      return
    end

    create_and_attach_composite_image(unique_album_arts.take(4))
  end
end

# == Schema Information
#
# Table name: playlists
#
#  id               :uuid             not null, primary key
#  title            :string           not null
#  subtitle         :string
#  description      :text
#  public           :boolean          default(TRUE), not null
#  user_id          :uuid
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  playlist_type_id :uuid
#  import_as_tandas :boolean          default(FALSE), not null
#
