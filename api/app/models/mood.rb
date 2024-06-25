class Mood < ApplicationRecord
  has_many :mood_tags, dependent: :destroy
  has_many :recordings, through: :mood_tags
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
