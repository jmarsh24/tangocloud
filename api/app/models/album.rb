class Album < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :audio_transfers, dependent: :destroy

  validates :title, presence: true
  validates :audio_transfers_count, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :slug, presence: true, uniqueness: true

  has_one_attached :album_art

  def search_data
    {
      title:,
      description:
    }
  end
end

# == Schema Information
#
# Table name: albums
#
#  id           :uuid             not null, primary key
#  title        :string           not null
#  description  :text
#  release_date :date
#  external_id  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
