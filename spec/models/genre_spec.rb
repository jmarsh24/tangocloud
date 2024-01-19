# frozen_string_literal: true

# == Schema Information
#
# Table name: genres
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "rails_helper"

RSpec.describe Genre, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
