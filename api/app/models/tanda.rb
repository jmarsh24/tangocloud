class Tanda < ApplicationRecord
  has_many :tanda_recordings, dependent: :destroy
  has_many :recordings, through: :tanda_recordings
  has_many :playlist_items, as: :item, dependent: :destroy
  has_many :playlists, through: :playlist_items
  has_many :mood_tags, as: :taggable, dependent: :destroy
  has_many :moods, through: :mood_tags

  validates :name, presence: true
  validates :public, inclusion: {in: [true, false]}
end

# == Schema Information
#
# Table name: tandas
#
#  id          :uuid             not null, primary key
#  title       :string           not null
#  subtitle    :string
#  description :string
#  public      :boolean          default(TRUE), not null
#  user_id     :uuid             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
