# frozen_string_literal: true

# == Schema Information
#
# Table name: transfer_agents
#
#  id          :uuid             not null, primary key
#  name        :string           not null
#  description :string
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "rails_helper"

RSpec.describe TransferAgent, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
