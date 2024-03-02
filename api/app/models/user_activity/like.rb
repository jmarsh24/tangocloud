module UserActivity
  class Like < ApplicationRecord
    self.table_name = "likes"
    belongs_to :user
    belongs_to :likeable, polymorphic: true
  end
end

# == Schema Information
#
# Table name: likes
#
#  id            :uuid             not null, primary key
#  likeable_type :string
#  likeable_id   :uuid
#  user_id       :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
