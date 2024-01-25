# frozen_string_literal: true

# == Schema Information
#
# Table name: user_preferences
#
#  id         :uuid             not null, primary key
#  username   :string           not null
#  first_name :string
#  last_name  :string
#  gender     :string
#  birth_date :string
#  locale     :string           default("en"), not null
#  user_id    :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe UserPreference, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
