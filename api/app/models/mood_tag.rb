class MoodTag < ApplicationRecord
  belongs_to :mood
  belongs_to :taggable, polymorphic: true
  belongs_to :user

  validates :mood_id, presence: true
  validates :user_id, presence: true
  validates :taggable_id, presence: true
  validates :taggable_type, presence: true
  validates :mood_id, uniqueness: {scope: [:taggable_type, :taggable_id, :user_id], message: "already has this mood from this user"}
end

# == Schema Information
#
# Table name: mood_tags
#
#  id            :uuid             not null, primary key
#  mood_id       :uuid             not null
#  taggable_type :string           not null
#  taggable_id   :uuid             not null
#  user_id       :uuid             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
