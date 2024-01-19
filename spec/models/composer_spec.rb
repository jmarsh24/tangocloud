# frozen_string_literal: true

# == Schema Information
#
# Table name: composers
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  birth_date :date
#  death_date :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Composer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
