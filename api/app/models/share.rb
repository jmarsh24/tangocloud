class Share < ApplicationRecord
  belongs_to :user
  belongs_to :shareable, polymorphic: true

  validates :user_id, presence: true
  validates :shareable_id, presence: true
  validates :shareable_type, presence: true
  validates :user_id, uniqueness: {scope: [:shareable_type, :shareable_id], message: "has already shared this item"}
end

# == Schema Information
#
# Table name: shares
#
#  id             :uuid             not null, primary key
#  user_id        :uuid             not null
#  shareable_type :string           not null
#  shareable_id   :uuid             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
