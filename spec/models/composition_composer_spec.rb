# frozen_string_literal: true

# == Schema Information
#
# Table name: composition_composers
#
#  id             :integer          not null, primary key
#  composition_id :integer          not null
#  composer_id    :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require "rails_helper"

RSpec.describe CompositionComposer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
