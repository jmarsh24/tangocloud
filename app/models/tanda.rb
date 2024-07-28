class Tanda < ApplicationRecord
  belongs_to :user
  has_many :tanda_recordings, dependent: :destroy
  has_many :recordings, through: :tanda_recordings
  has_many :playlist_items, as: :item, dependent: :destroy
  has_many :playlists, through: :playlist_items
  has_many :shares, as: :shareable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

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
