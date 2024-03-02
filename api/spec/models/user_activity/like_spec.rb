require "rails_helper"

RSpec.describe UserActivity::Like, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
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
