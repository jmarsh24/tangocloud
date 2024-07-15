class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :taggable, polymorphic: true
  belongs_to :user

  validates :tag, presence: true
  validates :user, presence: true
end

# == Schema Information
#
# Table name: taggings
#
#  id            :uuid             not null, primary key
#  tag_id        :uuid             not null
#  taggable_type :string           not null
#  taggable_id   :uuid             not null
#  user_id       :uuid             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
