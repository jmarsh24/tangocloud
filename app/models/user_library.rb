class UserLibrary < ApplicationRecord
  belongs_to :user
  has_many :library_items, dependent: :destroy
end

# == Schema Information
#
# Table name: user_libraries
#
#  id         :uuid             not null, primary key
#  user_id    :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
