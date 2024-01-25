# frozen_string_literal: true

# == Schema Information
#
# Table name: recording_singers
#
#  id           :uuid             not null, primary key
#  recording_id :uuid             not null
#  singer_id    :uuid             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require "rails_helper"

RSpec.describe RecordingSinger, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
