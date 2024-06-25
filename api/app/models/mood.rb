class Mood < ApplicationRecord
  has_many :mood_tags, dependent: :destroy
  has_many :taggable_recordings, through: :mood_tags, source: :taggable, source_type: "Recording"
  has_many :taggable_tandas, through: :mood_tags, source: :taggable, source_type: "Tanda"
  has_many :users, through: :mood_tags

  validates :name, presence: true, uniqueness: true
end

# == Schema Information
#
# Table name: moods
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
