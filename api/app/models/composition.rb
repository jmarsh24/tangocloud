class Composition < ApplicationRecord
  belongs_to :lyricist, optional: true, counter_cache: true
  belongs_to :composer, optional: true, counter_cache: true
  has_many :recordings, dependent: :destroy
  has_many :composition_lyrics, dependent: :destroy
  has_many :lyrics, through: :composition_lyrics

  validates :title, presence: true
end

# == Schema Informationy
#
# Table name: compositions
#
#  id               :uuid             not null, primary key
#  title            :string           not null
#  tangotube_slug   :string
#  lyricist_id      :uuid
#  composer_id      :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  recordings_count :integer          default(0)
#
