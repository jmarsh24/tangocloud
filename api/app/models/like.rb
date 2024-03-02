class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  validates :user_id, uniqueness: {scope: [:likeable_type, :likeable_id], message: "has already liked this"}
  validates :likeable_type, inclusion: {in: ["Recording"], message: "is not a valid type"}
end

# == Schema Information
#
# Table name: likes
#
#  id            :uuid             not null, primary key
#  likeable_type :string           not null
#  likeable_id   :uuid             not null
#  user_id       :uuid             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
