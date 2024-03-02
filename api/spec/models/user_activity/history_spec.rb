require "rails_helper"

RSpec.describe UserActivity::History, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: histories
#
#  id         :uuid             not null, primary key
#  user_id    :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
