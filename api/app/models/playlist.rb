class Playlist < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  searchkick word_middle: [:title]

  before_validation :set_default_title
  before_save_commit :attach_default_image, if: -> { image.blank? }

  validates :title, presence: true

  belongs_to :user
  has_many :playlist_items, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :playlist
  has_many :recordings, through: :playlist_items, source: :playable, source_type: "Recording"

  has_one_attached :image, dependent: :purge_later do |blob|
    blob.variant :thumb, resize_to_limit: [100, 100]
    blob.variant :medium, resize_to_limit: [250, 250]
    blob.variant :large, resize_to_limit: [500, 500]
  end
  has_one_attached :playlist_file, dependent: :purge_later

  scope :public_playlists, -> { where(public: true) }
  scope :system_playlists, -> { where(system: true) }

  def self.search_playlists(query = "*")
    search(
      query,
      fields: [:title],
      match: :word_middle,
      misspellings: {below: 5}
    )
  end

  def search_data
    {
      title:
    }
  end

  private

  def set_default_title
    self.title = playlist_file.filename.to_s.split(".").first if title.blank? && playlist_file.attached?
  end

  def attach_default_image
    unique_album_arts = recordings.includes(audio_transfers: {album: {album_art_attachment: :blob}})
      .flat_map(&:audio_transfers)
      .map(&:album)
      .compact
      .map(&:album_art)
      .uniq

    if unique_album_arts.size < 4
      unique_album_arts.first&.attach(image) if unique_album_arts.any? && unique_album_arts.first.attached?
      return
    end

    create_and_attach_composite_image(unique_album_arts.take(4))
  end

  def create_and_attach_composite_image(album_arts)
    part_width = 500
    part_height = 500

    images = album_arts.map do |album_art|
      img = Vips::Image.new_from_buffer(album_art.download, "")
      img.resize(part_width.to_f / img.width, vscale: part_height.to_f / img.height)
    end

    composite = Vips::Image.arrayjoin(images, across: 2)

    output_path = Rails.root.join("tmp", "#{SecureRandom.hex}.png").to_s
    composite.write_to_file(output_path)

    image.attach(io: File.open(output_path), filename: "composite_image.png", content_type: "image/png")

    File.delete(output_path) if File.exist?(output_path)
  end
end

# == Schema Information
#
# Table name: playlists
#
#  id                   :uuid             not null, primary key
#  title                :string           not null
#  description          :string
#  public               :boolean          default(TRUE), not null
#  likes_count          :integer          default(0), not null
#  listens_count        :integer          default(0), not null
#  shares_count         :integer          default(0), not null
#  followers_count      :integer          default(0), not null
#  user_id              :uuid             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  slug                 :string
#  system               :boolean          default(FALSE), not null
#  playlist_items_count :integer          default(0)
#
