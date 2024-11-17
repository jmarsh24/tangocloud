module Playlistable
  extend ActiveSupport::Concern

  included do
    searchkick word_start: [:title, :description]

    before_validation :set_default_title

    validates :title, presence: true

    has_many :likes, as: :likeable, dependent: :destroy
    has_many :shares, as: :shareable, dependent: :destroy
    belongs_to :user, optional: true

    has_one_attached :image, dependent: :purge_later
    has_one_attached :playlist_file, dependent: :purge_later

    scope :public_playlists, -> { where(public: true) }
  end

  def set_default_title
    self.title = playlist_file.filename.to_s.split(".").first if title.blank?
  end

  def create_and_attach_composite_image(album_arts)
    part_width = 500
    part_height = 500

    images = album_arts.map do |album_art|
      img = Vips::Image.new_from_buffer(album_art.download, "")

      img = img.colourspace("srgb") if img.bands == 1
      img = img.bandjoin(255) if img.bands == 3

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
