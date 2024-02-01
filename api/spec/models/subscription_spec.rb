require "rails_helper"

RSpec.describe Subscription, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: subscriptions
#
#  id                  :uuid             not null, primary key
#  name                :string           not null
#  description         :string
#  start_date          :datetime         not null
#  end_date            :datetime         not null
#  action_auth_user_id :uuid
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  subscription_type   :enum             default("free"), not null
#
