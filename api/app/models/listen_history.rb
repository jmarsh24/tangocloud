class ListenHistory < ApplicationRecord
  belongs_to :user
  has_many :listens
end

# == Schema Information
#
# Table name: listen_histories
#
#  id         :uuid             not null, primary key
#  user_id    :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
