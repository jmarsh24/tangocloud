class Playlist < ApplicationRecord
  include Playlistable

  searchkick word_start: [:title, :subtitle, :description, :recording_titles, :tanda_titles, :playlist_type]

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

  scope :public_playlists, -> { where(public: true) }
  scope :mood_playlists, -> { where(playlist_type: PlaylistType.find_by(name: "Mood")) }
  scope :excluding_mood_playlists, -> { where.not(playlist_type: PlaylistType.find_by(name: "Mood")) }

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

  private

  scope :search_import, -> {
    includes(
      recordings: :composition,
      tandas: {recordings: :composition},
      playlist_items: [:item]
    )
  }

  def search_data
    {
      title: title,
      subtitle: subtitle,
      description: description,
      recording_titles: recordings.filter_map { |recording| recording.composition&.title },
      tanda_titles: tandas.flat_map { |tanda| tanda.recordings.map { |recording| recording.composition&.title } }.compact,
      playlist_type: playlist_type&.name,
      playlist_items: playlist_items.map do |item|
        if item.item_type == "Recording"
          item.item.composition&.title
        elsif item.item_type == "Tanda"
          item.item.recordings.map { |recording| recording.composition&.title }
        end
      end.flatten.compact
    }
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
#  slug             :string
#
