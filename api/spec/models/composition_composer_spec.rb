require "rails_helper"

RSpec.describe CompositionComposer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: composition_composers
#
#  id             :uuid             not null, primary key
#  composition_id :uuid             not null
#  composer_id    :uuid             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
