class Playlist < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  searchkick word_start: [:title, :description]

  before_validation :set_default_title

  validates :title, presence: true

  has_many :playlist_items, -> { ordered }, dependent: :destroy, inverse_of: :playlist
  has_many :recordings, through: :playlist_items

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :shares, as: :shareable, dependent: :destroy
  belongs_to :user

  alias_method :items, :playlist_items

  has_one_attached :image, dependent: :purge_later
  has_one_attached :playlist_file, dependent: :purge_later

  scope :public_playlists, -> { where(public: true) }
  scope :system_playlists, -> { where(system: true) }

  def set_default_title
    self.title = playlist_file.filename.to_s.split(".").first if title.blank?
  end

  def attach_default_image
    unique_album_arts = recordings.includes(digital_remasters: {album: {album_art_attachment: :blob}})
      .filter_map { _1.digital_remasters.first.album.album_art }
      .uniq

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

  private

  def search_data
    {
      title:,
      description:
    }
  end
end

# == Schema Information
#
# Table name: playlists
#
#  id          :uuid             not null, primary key
#  title       :string           not null
#  subtitle    :string
#  description :text
#  slug        :string
#  public      :boolean          default(TRUE), not null
#  system      :boolean          default(FALSE), not null
#  user_id     :uuid             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
