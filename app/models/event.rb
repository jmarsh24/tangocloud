class Event < ApplicationRecord
  belongs_to :user

  before_create do
    self.user_agent = Current.user_agent
    self.ip_address = Current.ip_address
  end
end

# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  action     :string           not null
#  user_agent :string
#  ip_address :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
