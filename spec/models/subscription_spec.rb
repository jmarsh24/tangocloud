# frozen_string_literal: true

# == Schema Information
#
# Table name: subscriptions
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :string
#  type        :integer          default("free"), not null
#  start_date  :datetime         not null
#  end_date    :datetime         not null
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "rails_helper"

RSpec.describe Subscription, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
