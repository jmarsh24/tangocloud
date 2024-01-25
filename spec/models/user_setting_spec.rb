# frozen_string_literal: true

# == Schema Information
#
# Table name: user_settings
#
#  id         :uuid             not null, primary key
#  user_id    :uuid             not null
#  admin      :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe UserSetting, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
