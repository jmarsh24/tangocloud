class Playlist < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  searchkick word_middle: [:title]

  validates :title, presence: true

  belongs_to :user
  has_many :playlist_items, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :playlist
  has_many :recordings, through: :playlist_items, source: :playable, source_type: "Recording"

  has_one_attached :image, dependent: :purge_late
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
