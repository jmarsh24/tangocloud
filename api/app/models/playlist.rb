class Playlist < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  searchkick word_middle: [:title, :description]

  before_validation :set_default_title

  validates :title, presence: true

  belongs_to :user
  has_many :playlist_items, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :playlist
  has_many :recordings, through: :playlist_items, source: :playable, source_type: "Recording"
  has_many :audio_transfers, through: :recordings
  has_many :albums, through: :audio_transfers

  has_one_attached :image, dependent: :purge_later
  has_one_attached :playlist_file, dependent: :purge_later

  scope :public_playlists, -> { where(public: true) }
  scope :system_playlists, -> { where(system: true) }

  def search_data
    {
      title:,
      description:
    }
  end

  def set_default_title
    self.title = playlist_file.filename.to_s.split(".").first if title.blank?
  end

  def attach_default_image
    unique_albums = albums.with_attached_album_art.uniq
    unique_album_arts = unique_albums.map(&:album_art)

    if unique_album_arts.size < 4
      image.attach(unique_album_arts.first.blob)
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
#  slug                 :string
#  public               :boolean          default(TRUE), not null
#  songs_count          :integer          default(0), not null
#  likes_count          :integer          default(0), not null
#  playbacks_count      :integer          default(0), not null
#  shares_count         :integer          default(0), not null
#  followers_count      :integer          default(0), not null
#  playlist_items_count :integer          default(0), not null
#  system               :boolean          default(FALSE), not null
#  user_id              :uuid             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
